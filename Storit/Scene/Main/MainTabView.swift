//
//  TabView.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    let store: StoreOf<MainTabReducer>
    
    var body: some View {
        WithPerceptionTracking {
            TabView {
                DashBoardCoordinatorView(store: store.scope(state: \.dashBoard, action: \.dashBoard))
                    .tabItem {
                        Label("메인", systemImage: "house")
                    }
                    .accentColor(.stYellow)
                
                ChatListCoordinatorView(store: store.scope(state: \.chatList, action: \.chatList))
                    .tabItem {
                        Label("내 스토리", systemImage: "ellipses.bubble")
                    }
                    .accentColor(.stYellow)
                
                BoardCoordinatorView(store: store.scope(state: \.board, action: \.board))
                    .tabItem {
                        Label("커뮤니티", systemImage: "books.vertical")
                    }
                    .accentColor(.stYellow)
                
                MyPageCoordinatorView(store: store.scope(state: \.myPage, action: \.myPage))
                    .tabItem {
                        Label("마이페이지", systemImage: "person")
                    }
                    .accentColor(.stYellow)
            }
            .accentColor(.stYellow)
            .background(.stBlack)
            .toolbarBackground(.stBlack, for: .tabBar)
        }
    }
}


#Preview {
    MainTabView(
        store: Store(initialState: MainTabReducer.State(), reducer: {
            MainTabReducer()
        })
    )
}
