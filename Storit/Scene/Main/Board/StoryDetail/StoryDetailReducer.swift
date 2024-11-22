//
//  StoryDetailReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/10/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StoryDetailReducer {
    
    @ObservableState
    struct State: Identifiable, Equatable {
        var id = UUID()
//        let storyDetailModel: StoryModel
        var storyDetailModel: BoardDTO
        let isPublic: Bool // 커뮤니티에 게시된 경우 true
        var showFailToast: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tapLikeButton
        case tapShareButton
        case tapUploadButton
        case tapBackButton
        case setLikes
        case reportStory
        case failToast(isPresented: Bool)
    }
    
    @Dependency(\.boardClient) var boardClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .tapLikeButton:
                let boardId = state.storyDetailModel.boardId
                
                return .run { send in
                    if let result = await boardClient.likeBoard(boardId),
                       let _ = result.message {
                        await send(.setLikes)
                    }
                }
                
            case .tapShareButton:
                return .none
                
            case .reportStory:
                let boardId = state.storyDetailModel.boardId
                let req = ReportBoardRequest(reason: "reason")
                
                return .run { send in
                    if let result = await boardClient.reportBoard(boardId, req) {
                        await send(.tapBackButton)
                    } else {
                        await send(.failToast(isPresented: true))
                    }
                }
            
            case .tapUploadButton:
                let req = CreateBoardRequest(storyId: state.storyDetailModel.boardId)
                
                return .run { send in
                    if let result = await boardClient.createBoard(req) {
                        await send(.tapBackButton)
                    } else {
                        await send(.failToast(isPresented: true))
                    }
                }
                
            case .tapBackButton:
                return .none
                
            case .setLikes:
                state.storyDetailModel.likes += 1
                return .none
                
            case let .failToast(isPresented):
                state.showFailToast = isPresented
                return .none
            }
        }
    }
}
