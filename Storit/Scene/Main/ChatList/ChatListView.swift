//
//  ChatListView.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/7/24.
//

import SwiftUI
import ComposableArchitecture

struct ChatListView: View {
    let store : StoreOf<ChatListReducer>
    
    @State private var showAlert: Bool = false
    @State private var deleteStoryId: String = ""
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 20) {
                TitleView(title: "내 스토리")
                
                if store.chatItems.isEmpty {
                    Spacer()
                    
                    Text("아직 작성된 스토리가 없어요 \n 스토리를 작성해 볼까요?")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.stYellow)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(
                                store.scope(state: \.chatItems, action: \.chatItems)
                            ) { item in
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
//                                .padding(.horizontal, 16)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .fill(Color.stBlack.opacity(0.8))
//                                        .shadow(
//                                            color: .stYellow.opacity(0.7),
//                                            radius: 10,
//                                            x: 0,
//                                            y: 0
//                                        )
//                                )
                                .onTapGesture {
                                    store.send(.tapChatItem(storyModel: item.storyModel))
//                                    withAnimation(.easeInOut(duration: 0.2)) {
//                                        store.send(.tapChatItem(storyModel: item.storyModel))
//                                    }
                                }
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke(Color.stYellow, lineWidth: 1)
//                                )
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
//                                .shadow(
//                                    color: .gray.opacity(0.8),
//                                    radius: CGFloat(3),
//                                    x: CGFloat(0),
//                                    y: CGFloat(0)
//                                )
                            }
                        }
                    }
                    .padding(.top, 5)
                    .scrollIndicators(.hidden)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(.stBlack)
//            .background(
//                LinearGradient(
//                    colors: [Color.stBlack, Color.stBlack.opacity(0.9)],
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//            )
            .onAppear {
                store.send(.getMyStories)
            }
        }
    }
}

#Preview {
    ChatListView(
        store: Store(
            initialState: ChatListReducer.State(),
            reducer: { ChatListReducer() })
    )
}
