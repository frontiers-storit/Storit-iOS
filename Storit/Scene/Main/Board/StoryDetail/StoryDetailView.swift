//
//  StoryDetailView.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/10/24.
//

import SwiftUI
import ComposableArchitecture
import AlertToast

struct StoryDetailView: View {
    let store: StoreOf<StoryDetailReducer>
    
    @State private var isShowingActivityView = false
    @State private var showReportAlert = false
    @State private var showFailToast = false
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                navigationBar()
                    .frame(height: 48)
                
                storyContentView()
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .background(.stGray1)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .tabBar)
            .padding(.bottom, 16)
            .background(.stBlack)
            .background(
                ActivityView(isPresented: $isShowingActivityView, activityItems: ["https://storit-web-909260373550.asia-northeast3.run.app/post/\(store.storyDetailModel.boardId)"])
            )
            .toast(
                isPresenting: $showFailToast,
                duration: 2.0,
                tapToDismiss:
                    true,
                alert: { alertToastView(title: "잠시후 다시 시도해주세요.") },
                completion: {
                    showFailToast = false
                    store.send(.failToast(isPresented: false))
                }
            )
            .onChange(of: store.showFailToast) { value in
                showFailToast = value
            }
        }
    }
    
    private func navigationBar() -> some View {
        HStack {
            Button(action: {
                store.send(.tapBackButton)
            }, label: {
                Image(systemName: "arrow.backward")
            })
            .accentColor(.stYellow)
            .frame(width: 30)
            
            Spacer()
            
        }
        .padding(.horizontal, 16)
    }
    
    private func storyContentView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(store.storyDetailModel.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.stYellow)
                
                Spacer()
            }
            .padding(.bottom, 20)
            
            
            HStack(spacing: 0) {
                if let userName = store.storyDetailModel.userName {
                    Text("작가 : \(userName)")
                        .font(.caption)
                        .foregroundColor(.stYellow)
                }
                
                Spacer()
                
                Text("게시일 : \(store.storyDetailModel.createDate.timestamptoDate().formatTo())")
                    .font(.caption)
                    .foregroundColor(.stYellow)
            }
            .padding(.bottom, 17)
            
            if #available(iOS 16.4, *) {
                ScrollView(showsIndicators: false) {
                    Text(store.storyDetailModel.content)
                        .font(.caption)
                        .foregroundColor(.stYellow)
                }
                .padding(.bottom, 20)
                .scrollBounceBehavior(.basedOnSize)
            } else {
                ScrollView(showsIndicators: false) {
                    Text(store.storyDetailModel.content)
                        .font(.caption)
                        .foregroundColor(.stYellow)
                }
                .padding(.bottom, 20)
            }
            
            if store.isPublic {
                if store.storyDetailModel.userId != AuthenticationManager.shared.currentUser()?.uid {
                    HStack {
                        button(
                            title: "👍🏻 좋아요 \(store.storyDetailModel.likes)",
                            action: { store.send(.tapLikeButton)}
                        )
                        
                        button(
                            title: "🔗 공유하기",
                            action: { isShowingActivityView = true }
                        )
                        
                        button(
                            title: "🚨 신고하기",
                            action: { showReportAlert.toggle() }
                        )
                        .alert(isPresented: $showReportAlert) {
                            Alert(
                                title: Text("신고하기"),
                                message: Text("이 스토리를 신고하시겠어요? \n신고시 이 스토리를 더 이상 볼 수 없어요."),
                                primaryButton: .destructive(
                                    Text("신고"),
                                    action : {
                                        store.send(.reportStory)
                                    }
                                ),
                                secondaryButton: .default(Text("취소"))
                            )
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        
                        button(
                            title: "🔗 공유하기",
                            action: { isShowingActivityView = true }
                        )
                        
                        Spacer()
                    }
                }
                
                
            } else {
                button(
                    title: "✍🏻 커뮤니티 게시하기",
                    action: { store.send(.tapUploadButton)}
                )
            }
        }
    }
    
    private func button(title: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .font(.caption)
                .foregroundColor(.stBlack)
        })
        .frame(width: 105, height: 38)
        .background(Color.stYellow)
        .cornerRadius(8)
    }
}

//#Preview {
//    StoryDetailView(
//        store: Store(
//            initialState: StoryDetailReducer.State(storyDetailModel: StoryModel(title: "시간 여행자의 일기", subtitle: "시간을 넘나드는 주인공의 모험 이야기...", content: "2045년 8월 15일, 나는 처음으로 시간 여행에 성공했다. 과거로의 여행은 생각했던 것보다 훨씬 더 복잡하고 위험했다...", author: "시간 탐험가", likes: 128, date: .now), isPublic: true),
//            reducer: { StoryDetailReducer() })
//    )
//}
