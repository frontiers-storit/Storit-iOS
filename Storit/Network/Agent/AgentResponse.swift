//
//  AgentUsageReponse.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/7/24.
//

import Foundation

struct AgentUsageResponse: Decodable {
    let plotAgent: AgentUsageInfo
    let editAgent: AgentUsageInfo
    let writeAgent: AgentUsageInfo
}

struct CallAgentResponse: Decodable {
    let title: String?
    let world_setting: String?
    let main_themes: [String]?
    let major_events: [MajorEvent]?
    let Assistance: String?
    let content: String?
}

struct MajorEvent: Decodable {
    let event: String
    let conflict: String
}

struct AgentUsageInfo: Decodable {
    let used: Int
    let limit: Int
    let lastUseDate: Int?
}

struct CompleteStoryResponse: Decodable {
    let content: String
}
