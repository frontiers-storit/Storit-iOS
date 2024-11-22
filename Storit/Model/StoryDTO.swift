//
//  StoryDTO.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/1/24.
//

import Foundation

struct StoryDTO: Decodable, Equatable {
    let content: String?
    let createDate: Int
    let creativity: Double
    let isCompleted: Bool
    let isOnBoards: Bool
    let messages: [Int: MessageDTO]?
    let modifyDate: Int
    let preferGenre: String
    let storyId: String
    let title: String?
    let userId: String
    let userName: String?
}

extension StoryDTO {
   
    func toEntity() -> StoryModel {
        
        return StoryModel(content: content ?? "",
                          createDate: createDate.timestamptoDate(),
                          creativity: creativity,
                          isCompleted: isCompleted,
                          isOnBoards: isOnBoards,
                          modifyDate: modifyDate.timestamptoDate(),
                          preferGenre: preferGenre,
                          storyId: storyId,
                          title: title ?? "",
                          userId: userId,
                          userName: userName)
    }
}

struct StoryModel: Identifiable, Equatable, Hashable {
    var id = UUID()
    let content: String
    let createDate: Date
    let creativity: Double
    let isCompleted: Bool
    let isOnBoards: Bool
//    let messages: [MessageDTO]?
    let modifyDate: Date
    let preferGenre: String
    var storyId: String
    let title: String
    let userId: String
    let userName: String?
}


