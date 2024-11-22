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
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $selectedTab) {
                DashBoardCoordinatorView(store: store.scope(state: \.dashBoard, action: \.dashBoard))
                    .tabItem {
                        Label("메인", systemImage: "house")
                    }
                    .accentColor(.stYellow)
                    .tag(0)
                
                ChatListCoordinatorView(store: store.scope(state: \.chatList, action: \.chatList))
                    .tabItem {
                        Label("내 스토리", systemImage: "ellipses.bubble")
                    }
                    .accentColor(.stYellow)
                    .tag(1)
                
                BoardCoordinatorView(store: store.scope(state: \.board, action: \.board))
                    .tabItem {
                        Label("커뮤니티", systemImage: "books.vertical")
                    }
                    .accentColor(.stYellow)
                    .tag(2)
                
                MyPageCoordinatorView(store: store.scope(state: \.myPage, action: \.myPage))
                    .tabItem {
                        Label("마이페이지", systemImage: "person")
                    }
                    .accentColor(.stYellow)
                    .tag(3)
            }
            .accentColor(.stYellow)
            .background(.stBlack)
            .toolbarBackground(.stBlack, for: .tabBar)
            .onReceive(
                NotificationCenter.default.publisher(for: .goToSecondTab)
            ) { _ in
                selectedTab = 1
            }
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
