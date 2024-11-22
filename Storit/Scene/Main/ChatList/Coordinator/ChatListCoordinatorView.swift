//
//  ChatListCoordinatorView.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/7/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct ChatListCoordinatorView: View {
    let store: StoreOf<ChatListCoordinatorReducer>
   
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .chatList(store):
                    ChatListView(store: store)
                case let .chat(store):
                    ChatView(store: store)
                case let .storyDetail(store):
                    StoryDetailView(store: store)
                }
            }
        }
    }
}
