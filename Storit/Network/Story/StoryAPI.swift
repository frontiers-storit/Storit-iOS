//
//  StoryAPI.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/6/24.
//

import Foundation
import Alamofire

enum StoryAPI {
    case createStory(req: CreateStoryRequest)
    case updateStory(storyId: String, req: UpdateStoryRequest)
    case getMyStories
    case deleteStory(storyId: String)
}

extension StoryAPI: EndPoint {
    
    var baseURL: String {
        return "https://storit-api-909260373550.asia-northeast3.run.app"
    }
    
    var path: String {
        switch self {
        case .createStory:
            return "/api/v1/stories/"
        case let .updateStory(storyId, _):
            return "/api/v1/stories/\(storyId)"
        case .getMyStories:
            return "/api/v1/stories/my"
        case let .deleteStory(storyId):
            return "/api/v1/stories/\(storyId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createStory:
            return .post
        case .updateStory:
            return .put
        case .getMyStories:
            return .get
        case .deleteStory:
            return .delete
        }
    }
    
    var task: APITask {
        switch self {
        case let .createStory(story):
            return .requestBody(body: story)
        case let .updateStory(_, body):
            return .requestBody(body: body)
        case .getMyStories:
            return .requestPlain
        case .deleteStory:
            return .requestPlain
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
