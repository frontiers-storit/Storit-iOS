//
//  DashBoardCoordinatorReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum DashBoardRouteScreen {
    case dashBoard(DashBoardReducer)
    case agentSetting(AgentSettingReducer)
    case chat(ChatReducer)
    case admixer
}

@Reducer
struct DashBoardCoordinatorReducer {
    
    @ObservableState
    struct State: Equatable {
        var routes: [Route<DashBoardRouteScreen.State>]
    }
    
    enum Action {
        case router(IndexedRouterActionOf<DashBoardRouteScreen>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .dashBoard(.tapCreateProjectButton))):
                state.routes.presentCover(.agentSetting(.init()), embedInNavigationView: true)
                
            case let .router(.routeAction(id: _, action: .agentSetting(.moveToChatView(storyModel)))):
                state.routes.presentCover(.chat(.init(storyModel: storyModel)))
                
            case .router(.routeAction(id: _, action: .agentSetting(.tapCloseButton))):
                state.routes.dismiss()
                
            case .router(.routeAction(id: _, action: .chat(.tapBackButton))):
                state.routes.dismiss()
                
            case .router(.routeAction(id: _, action: .dashBoard(.tapTestAdMixerButton))):
                state.routes.push(.admixer)
                
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
