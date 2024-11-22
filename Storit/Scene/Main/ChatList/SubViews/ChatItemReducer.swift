//
//  ChatItemReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/11/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChatItemReducer {
    @ObservableState
    struct State: Identifiable, Equatable {
        var id: UUID
        let storyModel: StoryModel
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            }
        }
    }
}
