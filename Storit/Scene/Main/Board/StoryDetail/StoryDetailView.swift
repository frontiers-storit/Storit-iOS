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
            VStack(spacing: 15) {
                navigationBar()
                    .frame(height: 48)
                
                GeometryReader {
                    let size = $0.size
                    
                    HStack(spacing: 10) {
                        Image(.icTestBookCover)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.height, height: size.height)
                            .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                            .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(store.storyDetailModel.title)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.stYellow)
                            
                            if let userName = store.storyDetailModel.userName {
                                Text("By \(userName)")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                            }
                            
                            Text(store.storyDetailModel.createDate.timestamptoDate().formatTo())
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .frame(height: 150)

                StoryDetails()
            }
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .tabBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
    
    @ViewBuilder
    func StoryDetails() -> some View {
        VStack(spacing: 0) {
            ButtonView()
            
            Divider()
                .padding(.top, 15)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    Text(store.storyDetailModel.content)
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 15)
                .padding(.top, 10)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .padding([.horizontal, .top], 10)
    }
    
    @ViewBuilder
    func ButtonView() -> some View {
        if store.isPublic {
            if store.storyDetailModel.userId != AuthenticationManager.shared.currentUser()?.uid {
                HStack(spacing: 0) {
                    Button {
                        store.send(.tapLikeButton)
                    } label: {
                        Label("좋아요  \(store.storyDetailModel.likes)", systemImage: "hand.thumbsup")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button {
                        isShowingActivityView = true
                    } label: {
                        Label("공유하기", systemImage: "square.and.arrow.up")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button {
                        showReportAlert.toggle()
                    } label: {
                        Label("신고", systemImage: "light.beacon.max.fill")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
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
                    
                    Button {
                        isShowingActivityView = true
                    } label: {
                        Label("공유하기", systemImage: "square.and.arrow.up")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        } else {
            Button {
                store.send(.tapUploadButton)
            } label: {
                Label("커뮤니티 게시하기", systemImage: "pencil.and.scribble")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
}

//#Preview {
//    StoryDetailView(
//        store: Store(
//            initialState: StoryDetailReducer.State(storyDetailModel: StoryModel(title: "시간 여행자의 일기", subtitle: "시간을 넘나드는 주인공의 모험 이야기...", content: "2045년 8월 15일, 나는 처음으로 시간 여행에 성공했다. 과거로의 여행은 생각했던 것보다 훨씬 더 복잡하고 위험했다...", author: "시간 탐험가", likes: 128, date: .now), isPublic: true),
//            reducer: { StoryDetailReducer() })
//    )
//}
