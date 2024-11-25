//
//  ChatListView.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/7/24.
//

import SwiftUI
import ComposableArchitecture
import ActivityIndicatorView

struct ChatListView: View {
    let store : StoreOf<ChatListReducer>
    
    @State private var showAlert: Bool = false
    @State private var showLoadingIndicator: Bool = false
    @State private var deleteStoryId: String = ""
    
    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .center) {
                VStack(spacing: 20) {
                    TitleView(title: "내 스토리")
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    if store.chatItems.isEmpty {
                        Spacer()
                        
                        Text("아직 작성된 스토리가 없어요 \n 스토리를 작성해 볼까요?")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.stYellow)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack {
                                ForEach(store.scope(state: \.chatItems, action: \.chatItems)) { item in
                                    ChatItem(item)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 5)
                    }
                }
                
                if showLoadingIndicator {
                    LoadingView()
                }
            }
        }
        .background(.stBlack)
        .onAppear {
            store.send(.getMyStories)
        }
        .onChange(of: store.state.isLoading) { isLoading in
            showLoadingIndicator = isLoading
        }
    }
    
    @ViewBuilder
    func ChatItem(_ item: StoreOf<ChatItemReducer>) -> some View {
        ChatItemView(
            store: item,
            showStoryButtonAction: {
                store.send(.tapShowStoryButton(story: item.storyModel))
            },
            deleteStoryButtonAction: {
                deleteStoryId = item.storyModel.storyId
                showAlert.toggle()
            }
        )
        .padding(.bottom, 10)
        .onTapGesture {
            store.send(.tapChatItem(storyModel: item.storyModel))
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("스토리 삭제"),
                message: Text("스토리를 삭제하시겠어요? \n삭제시 돌이킬 수 없어요."),
                primaryButton: .destructive(
                    Text("삭제"),
                    action : {
                        store.send(.deleteStory(storyId: deleteStoryId))
                    }
                ),
                secondaryButton: .default(Text("취소"))
            )
        }
        .shadow(
            color: .gray.opacity(0.8),
            radius: CGFloat(3),
            x: CGFloat(0),
            y: CGFloat(0)
        )
    }
    
    @ViewBuilder
    func LoadingView() -> some View {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
            .overlay(
                ActivityIndicatorView(
                    isVisible: $showLoadingIndicator,
                    type: .rotatingDots(count: 5) //.scalingDots(count: 4, inset: 4)
                )
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(Color.stYellow)
            )
    }
}

#Preview {
    ChatListView(
        store: Store(
            initialState: ChatListReducer.State(),
            reducer: { ChatListReducer() })
    )
}
