//
//  AgentService.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/7/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct AgentClient {
    var getAgentUsage: () async -> AgentUsageResponse?
    var callPlotAgent: (CallAgentRequest) async -> CallAgentResponse?
    var callEditAgent: (CallAgentRequest) async -> CallAgentResponse?
    var callWriteAgent: (CallAgentRequest) async -> CallAgentResponse?
    var completeStory: (CompleteStoryRequest) async -> CompleteStoryResponse?
}

extension AgentClient: DependencyKey {
    static var liveValue: AgentClient {
        return AgentClient(
            getAgentUsage: {
                return await NetworkManager.shared.request(AgentAPI.getAgentUsage)
            },
            callPlotAgent: { req in
                return await NetworkManager.shared.request(AgentAPI.callPlotAgent(req: req))
            },
            callEditAgent: { req in
                return await NetworkManager.shared.request(AgentAPI.callEditAgent(req: req))
            },
            callWriteAgent: { req in
                return await NetworkManager.shared.request(AgentAPI.callWriteAgent(req: req))
            },
            completeStory: { req in
                return await NetworkManager.shared.request(AgentAPI.completeStory(req: req))
            }
        )
    }
}

extension DependencyValues {
    var agentClient: AgentClient {
        get { self[AgentClient.self] }
        set { self[AgentClient.self] = newValue }
    }
}
