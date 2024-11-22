//
//  AgentAPI.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/7/24.
//

import Foundation
import Alamofire

enum AgentAPI {
    case getAgentUsage
    case callPlotAgent(req: CallAgentRequest)
    case callEditAgent(req: CallAgentRequest)
    case callWriteAgent(req: CallAgentRequest)
    case completeStory(req: CompleteStoryRequest)
}

extension AgentAPI: EndPoint {
    
    var baseURL: String {
        return "https://storit-api-909260373550.asia-northeast3.run.app"
    }
    
    var path: String {
        switch self {
        case .getAgentUsage:
            return "/api/v1/agent/usage"
        case .callPlotAgent:
            return "/api/v1/agent/plot"
        case .callEditAgent:
            return "/api/v1/agent/edit"
        case .callWriteAgent:
            return "/api/v1/agent/write"
        case .completeStory:
            return "/api/v1/agent/complete"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAgentUsage:
            return .get
        case .callPlotAgent, .callEditAgent, .callWriteAgent, .completeStory:
            return .post
        }
    }
    
    var task: APITask {
        switch self {
        case .getAgentUsage:
            return .requestPlain
        case let .callPlotAgent(body):
            return .requestBody(body: body)
        case let .callEditAgent(body):
            return .requestBody(body: body)
        case let .callWriteAgent(body):
            return .requestBody(body: body)
        case let .completeStory(body):
            return .requestBody(body: body)
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        default:
            let token = AuthenticationManager.shared.userToken ?? ""

            return["Authorization": "Bearer \(token)",
                   "Content-Type": "application/json"]
        }
    }
}
