//
//  FirebaseManager.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/17/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class FirebaseManager: NSObject {
    
    let auth: Auth
    let firestore: Firestore
    let realtimeDB: DatabaseReference
    
    static let shared = FirebaseManager()
    
    override init() {        
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.realtimeDB = Database.database().reference()
        
        super.init()
    }
}

extension FirebaseManager {
    
    // 메세지 전송
    func sendMessage(storyId: String, uid: String, message: String) async -> Bool {
        
        let timestamp = Date.now.toTimestamp()
        let chatDict = [
            "sender": uid,
            "content": message,
            "isAgent": false,
            "timestamp": timestamp
        ] as [String : Any]

        let messageSent = await withCheckedContinuation { continuation in
            realtimeDB
                .child(Collection.users)
                .child(uid)
                .child(Collection.writedStories)
                .child(storyId)
                .child(Collection.messages)
                .child("\(timestamp)")
                .setValue(chatDict) { error, _ in
                    if let error = error {
                        print("Error writing message: \(error.localizedDescription)")
                        continuation.resume(returning: false)
                    } else {
                        print("Message sent successfully.")
                        continuation.resume(returning: true)
                    }
                }
        }
                
        // If the message was sent successfully, update the latest message
        if messageSent {
            return await sendLastMessage(storyId: storyId, uid: uid, message: message)
        }
        
        return false
    }
    
    // 마지막 메세지 전송
    func sendLastMessage(storyId: String, uid: String, message: String) async -> Bool {
        
        let timestamp = Date.now.toTimestamp()
        
        let lastMessageSent = await withCheckedContinuation { continuation in
            realtimeDB
                .child(Collection.users)
                .child(uid)
                .child(Collection.writedStories)
                .child(storyId)
                .child(Collection.latestMessage)
                .updateChildValues(["\(Collection.latestMessage)": message, "date": timestamp]) { error, _ in
                    if let error = error {
                        print("Error updating latest message: \(error.localizedDescription)")
                        continuation.resume(returning: false)
                    } else {
                        continuation.resume(returning: true)
                    }
                }
        }
        
        if lastMessageSent {
            return await updateModifyDate(storyId: storyId, uid: uid, timestamp: timestamp)
        }
        
        return false
    }
    
    // 수정 일 업데이트
    func updateModifyDate(storyId: String, uid: String, timestamp: Int) async -> Bool {
        return await withCheckedContinuation { continuation in
            realtimeDB
                .child(Collection.users)
                .child(uid)
                .child(Collection.writedStories)
                .child(storyId)
                .updateChildValues(["\(Collection.modifyDate)": timestamp]) { error, _ in
                    if let error = error {
                        print("Error updating ModifyDate: \(error.localizedDescription)")
                        continuation.resume(returning: false)
                    } else {
                        continuation.resume(returning: true)
                    }
                }
        }
    }
    
//    func getMessages(storyId: String, uid: String) async -> [ChatMessage] {
//        return await withCheckedContinuation { continuation in
//            var messages: [ChatMessage] = []
//            
//            realtimeDB
//                .child(Collection.users)
//                .child(uid)
//                .child(Collection.writedStories)
//                .child(storyId)
//                .child(Collection.messages)
//                .observe(.value)
//            { snapshot, _ in
//                if let snapshotValue = snapshot.value as? [String: Any] {
//                    messages = self.parseMessages(from: snapshotValue)
//                }
////                continuation.resume(returning: messages)
//                continuation.yield(messages)
//            }
//        }
//    }
    
    // 메세지들 구독한 채로 가져오기
    func subscribeToMessages(storyId: String, uid: String) -> AsyncStream<[ChatMessage]> {
        AsyncStream { continuation in
            realtimeDB
                .child(Collection.users)
                .child(uid)
                .child(Collection.writedStories)
                .child(storyId)
                .child(Collection.messages)
                .observe(.value) { snapshot in
                    var messages: [ChatMessage] = []
                    if let snapshotValue = snapshot.value as? [String: Any] {
                        messages = self.parseMessages(from: snapshotValue)
                    }
                    continuation.yield(messages) // 새 데이터를 스트림에 전달
                }
            
            // 클로저가 취소될 때 구독을 중지합니다.
            continuation.onTermination = { _ in
                self.realtimeDB
                    .child(Collection.users)
                    .child(uid)
                    .child(Collection.writedStories)
                    .child(storyId)
                    .child(Collection.messages)
                    .removeAllObservers()
            }
        }
    }
    
    // 내 스토리
    func getMyStories(uid: String) async -> [StoryDTO] {
        return await withCheckedContinuation { continuation in
            var stories: [StoryDTO] = []
            
            realtimeDB
                .child(Collection.users)
                .child(uid)
                .child(Collection.writedStories)
                .queryOrdered(byChild: "modifyDate")
                .observeSingleEvent(of: .value)
            { snapshot, _ in
                if let snapshotValue = snapshot.value as? [String: Any] {
                    stories = self.parseStories(from: snapshotValue)
                }
                continuation.resume(returning: stories)
            }
        }
    }
    
    // 내 작성중 스토리
    func getMyWritingStories(uid: String) async -> [StoryDTO] {
        return await withCheckedContinuation { continuation in            
            realtimeDB
                .child(Collection.users)
                .child(uid)
                .child(Collection.writedStories)
                .queryOrdered(byChild: "modifyDate")
                .observeSingleEvent(of: .value)
            { snapshot, _ in
                guard let snapshotValue = snapshot.value as? [String: Any] else {
                    continuation.resume(returning: [])
                    return
                }
                
                let stories = self.parseStories(from: snapshotValue).filter { !$0.isCompleted }
                continuation.resume(returning: stories)
            }
        }
    }
    
    // 사용자 데이터 삭제 (계정 탈퇴시)
    func deleteUserData(uid: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            realtimeDB.child(Collection.users).child(uid).removeValue() { error, _ in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}

extension FirebaseManager {
    func parseMessages(from snapshot: [String: Any]) -> [ChatMessage] {
        var messages: [ChatMessage] = []
        
        for (_, value) in snapshot {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let message = try JSONDecoder().decode(MessageDTO.self, from: jsonData)
                messages.append(message.toChatMessage())
            } catch {
                print("Error decoding chat message: \(error)")
            }
        }
        return messages
    }
    
    func parseStories(from snapshot: [String: Any]) -> [StoryDTO] {
        var stories: [StoryDTO] = []
        
        for (_, value) in snapshot {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let story = try JSONDecoder().decode(StoryDTO.self, from: jsonData)
                stories.append(story)
            } catch {
                print("Error decoding stories: \(error)")
            }
        }
        return stories
        
    }
}
