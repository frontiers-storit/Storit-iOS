//
//  UseAgentRequest.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/7/24.
//

import Foundation

struct CallAgentRequest: Encodable {
    let story_id: String
    let genre: String
    let creativity: Double
}

struct CompleteStoryRequest: Encodable {
    let story_id: String
}
