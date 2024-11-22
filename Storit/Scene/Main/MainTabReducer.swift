//
//  MainTabReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainTabReducer {
    
    @ObservableState
    struct State : Equatable {
    
        var dashBoard = DashBoardCoordinatorReducer.State(
            routes: [.root(.dashBoard(.init()), embedInNavigationView: true)]
        )
        
        var chatList = ChatListCoordinatorReducer.State(
            routes: [.root(.chatList(.init()), embedInNavigationView: true)]
        )
        
        var board = BoardCoordinatorReducer.State(
            routes: [.root(.board(.init()), embedInNavigationView: true)]
        )
        
        var myPage = MyPageCoordinatorReducer.State(
            routes: [.root(.myPage(.init()), embedInNavigationView: true)]
        )
    }
    
    enum Action {
        case dashBoard(DashBoardCoordinatorReducer.Action)
        case chatList(ChatListCoordinatorReducer.Action)
        case board(BoardCoordinatorReducer.Action)
        case myPage(MyPageCoordinatorReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.board, action: \.board) {
            BoardCoordinatorReducer()
        }
        
        Scope(state: \.dashBoard, action: \.dashBoard) {
            DashBoardCoordinatorReducer()
        }
        
        Scope(state: \.chatList, action: \.chatList) {
            ChatListCoordinatorReducer()
        }
        
        Scope(state: \.myPage, action: \.myPage) {
            MyPageCoordinatorReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .myPage(_), .board(_), .dashBoard(_), .chatList(_):
                return .none
            }
        }
    }
}
