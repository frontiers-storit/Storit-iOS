//
//  StoryRequest.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/7/24.
//

import Foundation

struct CreateStoryRequest: Encodable {
    let preferGenre: String
    let creativity: Double
}

struct UpdateStoryRequest: Encodable {
    let title: String
    let content: String
    let summary: String
    let isCompleted: Bool
}
