//
//  ChatListReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChatListReducer {
    
    @ObservableState
    struct State : Equatable {
        var chatItems: IdentifiedArrayOf<ChatItemReducer.State> = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case chatItems(IdentifiedActionOf<ChatItemReducer>)
        case tapChatItem(storyModel: StoryModel)
        case tapShowStoryButton(story: StoryModel)
        case getMyStories
        case setStories(stories: [StoryModel])
        case deleteStory(storyId: String)
    }
    
    @Dependency(\.storyClient) var storyClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .chatItems(_):
                return .none
                
            case .tapChatItem:
                return .none
            
            case .tapShowStoryButton:
                return .none
            
            case .getMyStories:
                state.isLoading = true
                
                return .run { send in
                    do {
                        let user = try AuthenticationManager.shared.getAuthenticatedUser()
                        let stories = await FirebaseManager.shared.getMyStories(uid: user.uid).map { $0.toEntity() }
                        await send(.setStories(stories: stories))
                    } catch let error {
                        print("getMyStories error: \(error)")
                        await send(.setStories(stories: []))
                    }
                }
            
            case let .setStories(stories):
                let storyItems = stories
                    .sorted { $0.modifyDate > $1.modifyDate }
                    .map { story in
                        ChatItemReducer.State(id: UUID(), storyModel: story)
                    }
                
                state.chatItems = IdentifiedArray(uniqueElements: storyItems)
                state.isLoading = false
                return .none
            
            case let .deleteStory(storyId):
                state.isLoading = true
                return .run { send in
                    if let _ = await storyClient.deleteStory(storyId) {
                        await send(.getMyStories)
                    }
                }
            }
        }
    }
}
