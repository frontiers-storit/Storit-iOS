//
//  BoardCoordinatorReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum BoardRouteScreen {
    case board(BoardReducer)
    case storyDetail(StoryDetailReducer)
}

@Reducer
struct BoardCoordinatorReducer {
    
    @ObservableState
    struct State: Equatable {
        var routes: [Route<BoardRouteScreen.State>]
    }
    
    enum Action {
        case router(IndexedRouterActionOf<BoardRouteScreen>)
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(id: _, action: .board(.tapStoryItem(model)))):
                state.routes.push(.storyDetail(.init(storyDetailModel: model, isPublic: true)))
              
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
