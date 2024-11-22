//
//  MessageDTO.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/22/24.
//

import Foundation

struct MessageDTO: Decodable, Equatable {
    let content: String
    let isAgent: Bool
    let sender: String
    let timestamp: Int
}

struct ChatMessage: Identifiable, Equatable, Hashable, Codable {
    var id = UUID().uuidString
    var text: String
    var user: ChatUser
    var date: Date
}


extension MessageDTO {
    func toChatMessage() -> ChatMessage {
        let user = ChatUser(id: sender, name: sender, avatarURL: nil, isCurrentUser: !isAgent)
        return ChatMessage(text: content, user: user, date: timestamp.timestamptoDate())
    }
}
