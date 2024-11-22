//
//  ChatView.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/15/24.
//

import SwiftUI
import ComposableArchitecture
import FloatingButton
import ActivityIndicatorView
import AlertToast

struct ChatView: View {
    let store: StoreOf<ChatReducer>
    
    @State private var messageText: String = ""
    @State private var showLoadingIndicator: Bool = false
    @State private var showFailToast = false
    
    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    navigationBar()
                        .frame(height: 48)
                    
                    ZStack(alignment: .bottomTrailing) {
                        messageViews()
                        
                        if !store.storyModel.isCompleted {
                            floatingButton()
                        }
                    }
                    
                    if !store.storyModel.isCompleted {
                        textfieldButtonBar()
                    }
                }
                
                if showLoadingIndicator {
                    loadingView()
                }
            }
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
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .background(.stBlack)
        .onAppear {
            UIApplication.shared.hideKeyboard()
            store.send(.getMessages)
        }
        .onChange(of: store.state.isLoading) { isLoading in
            showLoadingIndicator = isLoading
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
            
            Text(store.storyModel.title)
                .font(.caption)
                .foregroundColor(.stYellow)
                .shadow(color: .stYellow.opacity(0.8), radius: 6, x: 0, y: 0)
            
            Spacer()
            
            Spacer()
                .frame(width: 30)
        }
        .padding(.horizontal, 16)
    }
    
    private func messageViews() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(store.messages) { message in
                        MessageCell(message: message.text, isCurrentUser: message.user.isCurrentUser)
                            .id(message.text)
                    }
                }
                .onReceive(store.publisher.messages) { _ in
                    DispatchQueue.main.async {
                        withAnimation {
                            if let lastMessage = store.messages.last {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                .onAppear {
                    withAnimation {
                        if let lastMessage = store.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    private func textfieldButtonBar() -> some View {
        HStack {
            Button(action: {
                store.send(.tapCompleteButton)
            }, label: {
                Text("작성 완료")
                    .font(.caption2)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .foregroundStyle(.stYellow)
                    .background(.stGray2)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.stYellow, lineWidth: 1)
                    )
                    .disabled(store.isLoading)
            })
            .padding(.leading, 8)
            .padding(.vertical, 16)
            
            
            TextField(
                "메시지를 입력하세요",
                text: $messageText,
                prompt: Text("  메시지를 입력하세요...")
                        .font(.caption)
                        .foregroundColor(.gray)
            )
            .frame(height: 33)
            .foregroundColor(.stYellow)
            .background(.stBlack)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.stYellow, lineWidth: 1)
            )
            
            Button(action: {
                if !messageText.isEmpty {
                    store.send(.sendMessage(message: messageText))
                    messageText = ""
                }
            }, label: {
                Text("전송")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .foregroundStyle(.stBlack)
                    .background(.stYellow)
                    .cornerRadius(14)
                    .disabled(store.isLoading)
            })
            .padding(.trailing, 8)
            .padding(.vertical, 16)
        }
        .background(.stGray1)
    }
    
    private func floatingButton() -> some View {
        let mainButton1 = MainFloatingButton(image: Image(.icFloating), color: .stYellow)
            .background(.clear)
        
        let buttons = [AgentType.plot, AgentType.edit, AgentType.write].map { type in
            IconButton(image: type.iconImage, color: .stYellow)
                .onTapGesture {
                    store.send(.callAgent(type: type))
                }
        }
        
        return HStack {
            FloatingButton(mainButtonView: mainButton1, buttons: buttons)
                .straight()
                .direction(.right)
                .delays(delayDelta: 0.1)
            
            Spacer()
        }
        .padding(.horizontal, 12)
    }
    
    private func loadingView() -> some View {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
            .overlay(
                VStack(spacing: 10) {

                    store.agent.mascotImage
                        .resizable()
                        .frame(width: 130, height: 130)
                        .cornerRadius(12)
                        .shadow(
                            color: .white.opacity(0.8),
                            radius: CGFloat(5),
                            x: CGFloat(0),
                            y: CGFloat(0)
                        )
                                  
                    ActivityIndicatorView(
                        isVisible: $showLoadingIndicator,
                        type: .rotatingDots(count: 5) //.scalingDots(count: 4, inset: 4)
                    )
                    .frame(width: 30.0, height: 30.0)
                    .foregroundColor(Color.stYellow)
                    
                    
                    Text("\(store.agent.name)를 호출하고 있어요 \n잠시만 기다려주세요")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.stYellow)
                        .padding()
                }
            )
    }
}

//#Preview {
//    ChatView(
//        store: Store(
//            initialState: ChatReducer.State(storyModel: StoryModel()),
//            reducer: { ChatReducer() })
//    )
//}
