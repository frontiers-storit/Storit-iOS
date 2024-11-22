//
//  AppCoordinatorView.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/6/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinatorReducer>
    
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .splash(store):
                    SplashView(store: store)
                case let .login(store):
                    LoginView(store: store)
                case let .main(store):
                    MainTabView(store: store)
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(for: .goToLoginScreen)
            ) { _ in
                store.send(.goToLoginScreen)
            }
        }
    }
}
