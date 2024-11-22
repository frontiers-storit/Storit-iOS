//
//  StoryService.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/6/24.
//

import Foundation
import ComposableArchitecture
import Alamofire

@DependencyClient
struct StoryClient {
    var createStory: (CreateStoryRequest) async -> CreateStoryResponse?
    var updateStory: (String, UpdateStoryRequest) async -> UpdateStoryResponse?
    var deleteStory: (String) async -> DeleteStoryResponse?
}

extension StoryClient: DependencyKey {
    static var liveValue: StoryClient {
        return StoryClient(
            createStory: { req in
                return await NetworkManager.shared.request(StoryAPI.createStory(req: req))
            },
            updateStory: { storyId, req in
                return await NetworkManager.shared.request(StoryAPI.updateStory(storyId: storyId, req: req))
            },
            deleteStory: { storyId in
                return await NetworkManager.shared.request(StoryAPI.deleteStory(storyId: storyId))
            }
        )
    }
}

extension DependencyValues {
    var storyClient: StoryClient {
        get { self[StoryClient.self] }
        set { self[StoryClient.self] = newValue }
    }
}
