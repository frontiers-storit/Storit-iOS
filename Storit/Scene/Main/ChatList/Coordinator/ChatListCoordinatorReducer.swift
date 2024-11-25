//
//  ChatListCoordinatorReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/7/24.
//

import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum ChatListRouteScreen {
    case chatList(ChatListReducer)
    case chat(ChatReducer)
    case storyDetail(StoryDetailReducer)
}

@Reducer
struct ChatListCoordinatorReducer {
    
    @ObservableState
    struct State: Equatable {
        var routes: [Route<ChatListRouteScreen.State>]
    }
    
    enum Action {
        case router(IndexedRouterActionOf<ChatListRouteScreen>)
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(id: _, action: .chatList(.tapChatItem(storyModel)))):
                state.routes.push(.chat(.init(storyModel: storyModel)))
                
            case let .router(.routeAction(id: _, action: .chatList(.tapShowStoryButton(storyModel)))):
                
                let boardModel = BoardDTO(
                    boardId: storyModel.storyId,
                    title: storyModel.title ?? "",
                    content: storyModel.content,
                    summary: "",
                    views: 0,
                    likes: 0,
                    createDate: storyModel.createDate.toTimestamp(),
                    userId: storyModel.userId,
                    userName: storyModel.userName,
                    thumbnail: storyModel.thumbnail ?? "")
                
                state.routes.push(.storyDetail(.init(storyDetailModel: boardModel, isPublic: storyModel.isOnBoards)))

            case .router(.routeAction(id: _, action: .chat(.tapBackButton))):
                state.routes.pop()
                
            case .router(.routeAction(id: _, action: .storyDetail(.tapBackButton))):
                state.routes.pop()
            
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
