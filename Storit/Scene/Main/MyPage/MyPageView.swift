//
//  MyPageView.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
    let store : StoreOf<MyPageReducer>
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    userView
                    inCompleteListView
                    completeListView
                    
                    Button {
                        store.send(.tapLogoutButton)
                    } label: {
                        Text("로그아웃")
                    }
                    .buttonStyle(StoritButton())

                    Button {
                        showAlert.toggle()
                    } label: {
                        Text("탈퇴하기")
                    }
                    .buttonStyle(StoritButton())
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("계정 탈퇴하기"),
                            message: Text("스토릿 계정을 탈퇴하시겠어요? \n탈퇴시 돌이킬 수 없어요."),
                            primaryButton: .destructive(
                                Text("탈퇴"),
                                action : {
                                    store.send(.deleteAccount)
                                }
                            ),
                            secondaryButton: .default(Text("취소"))
                        )
                    }

                    Spacer()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(.stGray1)
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(.stBlack)
            .scrollBounceBehavior(.basedOnSize)
        }
        .onAppear {
            store.send(.getMyStories)
        }
    }
    
    private var userView: some View {
        
        HStack(spacing: 16) {
            Image(.icMascotNothing)
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(32)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.stYellow, lineWidth: 1)
                )
                .shadow(
                    color: .white.opacity(0.8),
                    radius: CGFloat(5),
                    x: CGFloat(0),
                    y: CGFloat(0)
                )
            
            VStack {
                HStack {
                    Text(AppData.nickname)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.stYellow)
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer()
                
                HStack {
                    Text("이메일: \(AuthenticationManager.shared.getUserEmail())")
                        .font(.system(size: 14))
                        .foregroundColor(.stYellow)
                    
                    Spacer()
                }
                .padding(.bottom, 10)
            }
        }
    }
    
    private var inCompleteListView: some View {
        
        VStack(spacing: 18) {
            HStack {
                Text("작성 중인 스토리")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.stYellow)
                
                Spacer()
            }
            
            if store.latestStories.isEmpty {
                HStack {
                    Text("작성 중인 스토리가 없어요")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.stYellow)
                    
                    Spacer()
                }
            } else {
                LazyVStack {
                    ForEach(store.latestStories, id: \.self) { storyModel in
                        StoryComponentView(storyModel: storyModel)
                            .onTapGesture {
                                store.send(.tapMyStory(storyModel: storyModel))
                            }
                    }
                }
            }
        }
    }
    
    private var completeListView: some View {
        
        VStack(spacing: 18) {
            HStack {
                Text("작성 완료한 스토리")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.stYellow)
                
                Spacer()
            }
            
            if store.latestStories.isEmpty {
                HStack {
                    Text("아직 작성 완료한 스토리가 없어요")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.stYellow)
                    
                    Spacer()
                }
            } else {
                LazyVStack {
                    ForEach(store.completedStories, id: \.self) { storyModel in
                        StoryComponentView(storyModel: storyModel)
                            .onTapGesture {
                                store.send(.tapMyStory(storyModel: storyModel))
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    MyPageView(
        store: Store(
            initialState: MyPageReducer.State(),
            reducer: { MyPageReducer() })
    )
}
