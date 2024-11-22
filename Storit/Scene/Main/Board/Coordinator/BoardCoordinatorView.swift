//
//  BoardCoordinator.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct BoardCoordinatorView: View {
    let store: StoreOf<BoardCoordinatorReducer>
    
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .board(store):
                    BoardView(store: store, selectedBook: nil)
                case let .storyDetail(store):
                    StoryDetailView(store: store)
                }
            }
        }
    }
}
