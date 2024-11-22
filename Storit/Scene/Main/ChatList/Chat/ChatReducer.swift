//
//  ChatReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/15/24.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
struct ChatReducer {
    
    @ObservableState
    struct State: Equatable {
        let storyModel: StoryModel
        var messages: IdentifiedArrayOf<ChatMessage> = []
        var isLoading: Bool = false
        var loadingMessage: String = "AI 에이전트를 호출하고 있어요.\n잠시만 기다려주세요."
        var agent: AgentType = .none
        var showFailToast: Bool = false
    }
    
    indirect enum Action {
        case tapBackButton
        case tapCompleteButton
        case getMessages
        case sendMessage(message: String)
        case setMessages(messages: [ChatMessage])
        case fail(ChatReducer.Action)
        case callAgent(type: AgentType)
        case completeLoading(isLoading: Bool)
        case setLoadingMessage(message: String)
        case failToast(isPresented: Bool)
    }
    
    @Dependency(\.agentClient) var agentClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapBackButton:
                state.isLoading = false
                return .none
                
            case .tapCompleteButton:
                if state.messages.count < 2 {
                    print(" 메세지를 보내야 작성을 완료할 수 있어요. ")
                    return .none
                }
                
                let req = CompleteStoryRequest(story_id: state.storyModel.storyId)
                state.isLoading = true
                state.agent = .none
                state.loadingMessage = "AI 에이전트를 호출하고 있어요.\n잠시만 기다려주세요."
                
                return .run { send in
                    if let result = await agentClient.completeStory(req) {
                        await send(.tapBackButton)
                    } else {
                        await send(.completeLoading(isLoading: false))
                        await send(.failToast(isPresented: true))
                    }
                }
                                
            case .getMessages:
                let storyId = state.storyModel.storyId
                return .run { send in
                    do {
                        let user = try AuthenticationManager.shared.getAuthenticatedUser()
                        for await messages in FirebaseManager.shared.subscribeToMessages(storyId: storyId, uid: user.uid) {
                            await send(.setMessages(messages: messages))
                        }
                    } catch let error {
                        print(" get Message error: \(error)")
                        await send(.fail(.getMessages))
                    }
                }
            
            case let .sendMessage(text):
                let storyId = state.storyModel.storyId
                return .run { send in
                    do {
                        let user = try AuthenticationManager.shared.getAuthenticatedUser()
                        let isSuccess = await FirebaseManager.shared.sendMessage(storyId: storyId, uid: user.uid, message: text)
                        
                        if !isSuccess {
                            await send (.fail(.sendMessage(message: text)))
                        }
                    } catch let error {
                        print(" sendMessage error: \(error)")
                        await send (.fail(.sendMessage(message: text)))
                    }
                }
            
            case let .setMessages(messages):
                
                state.messages = IdentifiedArrayOf(uniqueElements: messages.sorted { $0.date < $1.date })

                for message in state.messages {
                    print("message: \(message)")
                }
                
                return .none
            
            case let .fail(action):
                switch action {
                case .getMessages:
                    print(" fail get Message")
                case .sendMessage:
                    print(" fail send Message")
                default:
                    return .none
                }
            
            case let .callAgent(agent):
                
                let req = CallAgentRequest(
                    story_id: state.storyModel.storyId,
                    genre: state.storyModel.preferGenre,
                    creativity: state.storyModel.creativity
                )
                
                state.isLoading = true
                state.agent = agent

                return .run { send in
                    switch agent {
                    case .plot:
                        if let _ = await agentClient.callPlotAgent(req) {
                            await send(.completeLoading(isLoading: false))
                        } else {
                            await send(.completeLoading(isLoading: false))
                            await send(.failToast(isPresented: true))
                        }
                        
                    case .edit:
                        if let _ = await agentClient.callEditAgent(req) {
                            await send(.completeLoading(isLoading: false))
                        } else {
                            await send(.completeLoading(isLoading: false))
                            await send(.failToast(isPresented: true))
                        }
                       
                    default:
                        if let _ = await agentClient.callWriteAgent(req) {
                            await send(.completeLoading(isLoading: false))
                        } else {
                            await send(.completeLoading(isLoading: false))
                            await send(.failToast(isPresented: true))
                        }
                    }
                }
                
            case let .completeLoading(isLoading):
                state.isLoading = isLoading
                return .none
                
            case let .setLoadingMessage(message):
                state.loadingMessage = message
                return .none
                
            case let .failToast(isPresented):
                state.showFailToast = isPresented
                return .none
            }
            
            return .none
        }
    }
}
