//
//  DashBoardCoordinatorView.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct DashBoardCoordinatorView: View {
    let store: StoreOf<DashBoardCoordinatorReducer>
    
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .dashBoard(store):
                    DashBoardView(store: store)
                case let .agentSetting(store):
                    AgentSettingView(store: store)
                case let .chat(store):
                    ChatView(store: store)
                case .admixer:
                    AdMixerSettingView(viewModel: AdMixerSettingViewModel())
                }
            }
        }
    }
}
