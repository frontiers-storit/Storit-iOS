//
//  CreateStoryResponse.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/6/24.
//

import Foundation

struct CreateStoryResponse: Decodable {
    let storyId: String
}

struct UpdateStoryResponse: Decodable {
    
}

struct DeleteStoryResponse: Decodable {
    let StoryId: String
    let title: String
    let preferGenre: String
    let creativity: Double
    let deleteUserDB: Bool
    let deleteStoryDB: Bool
    let deleteBoardDB: Bool
}
