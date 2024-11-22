//
//  AppCoordinatorReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/6/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum AppRouteScreen {
    case splash(SplashReducer)
    case login(LoginReducer)
    case main(MainTabReducer)
}

@Reducer
struct AppCoordinatorReducer {
    
    @ObservableState
    struct State: Equatable {
        var routes: [Route<AppRouteScreen.State>]
    }
    
    enum Action {
        case router(IndexedRouterActionOf<AppRouteScreen>)
        case goToLoginScreen
        case goToMainScreen
        case resetTo(AppRouteScreen.State)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            
            case .router(.routeAction(_, action: .splash(.tokenRefreshFailed))):
                return .run { send in
                    await send(.goToLoginScreen)
                }
                
            case .router(.routeAction(_, action: .splash(.tokenRefreshSuccess))):
                return .run { send in
                    await send(.goToMainScreen)
                }
                
            case .router(.routeAction(_, action: .login(.goToMain))):
                return .run { send in
                    await send(.goToMainScreen)
                }
                
            case .goToLoginScreen:
                return .run { send in
                    await send(.resetTo(.login(.init())))
                }
            
            case .goToMainScreen:
                return .run { send in
                    await send (.resetTo(.main(.init())))
                }
                
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
