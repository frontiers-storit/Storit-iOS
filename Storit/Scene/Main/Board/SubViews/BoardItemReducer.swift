//
//  BoardItemReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/10/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BoardItemReducer {
    @ObservableState
    struct State: Identifiable, Equatable {
        var id: UUID
        var boardModel: BoardDTO
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
