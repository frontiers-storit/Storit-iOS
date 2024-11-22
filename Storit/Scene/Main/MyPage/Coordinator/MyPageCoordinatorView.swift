//
//  MyPageCoordinatorView.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/8/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct MyPageCoordinatorView: View {
    let store: StoreOf<MyPageCoordinatorReducer>
    
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .myPage(store):
                    MyPageView(store: store)
                case let .login(store):
                    LoginView(store: store)
                case let .chat(store):
                    ChatView(store: store)
                }
            }
        }
    }
}
