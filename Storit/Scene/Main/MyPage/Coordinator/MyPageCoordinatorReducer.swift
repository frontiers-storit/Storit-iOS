//
//  MyPageCoordinatorReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/8/24.
//

import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum MyPageRouteScreen {
    case myPage(MyPageReducer)
    case login(LoginReducer)
    case chat(ChatReducer)
}

@Reducer
struct MyPageCoordinatorReducer {
    
    @ObservableState
    struct State: Equatable {
        var routes: [Route<MyPageRouteScreen.State>]
    }
    
    enum Action {
        case router(IndexedRouterActionOf<MyPageRouteScreen>)
        case resetTo(MyPageRouteScreen.State)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
//            case .router(.routeAction(id: _, action: .myPage(.moveToLogin))):
//               break
            case let .router(.routeAction(id: _, action: .myPage(.tapMyStory(storyModel)))):
                state.routes.push(.chat(.init(storyModel: storyModel)))
                
            case .router(.routeAction(id: _, action: .chat(.tapBackButton))):
                state.routes.pop()
                
            case .resetTo(let routeState):
                state.routes = [
                    .root(routeState, embedInNavigationView: true)
                ]
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
