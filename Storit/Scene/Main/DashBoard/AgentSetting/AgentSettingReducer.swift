//
//  AgentSettingReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/17/24.
//

import ComposableArchitecture

@Reducer
struct AgentSettingReducer {
    
    @ObservableState
    struct State: Equatable {
        var sliderValue: Double = 5.0
        var agentGenre: AgentGenreType = .sf
        
    }
    
    enum Action {
        case tapStartButton
        case tapCloseButton
        case sliderValueChanged(Double)
        case setAgentGenre(AgentGenreType)
        case moveToChatView(storyModel: StoryModel)
    }
    
    @Dependency(\.storyClient) var storyClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapStartButton:
                let req = CreateStoryRequest(preferGenre: state.agentGenre.description, creativity: state.sliderValue / 10.0)
                var storyModel = StoryModel(content: "",
                                            createDate: .now,
                                            creativity: state.sliderValue / 10.0,
                                            isCompleted: false,
                                            isOnBoards: false,
                                            modifyDate: .now,
                                            preferGenre: state.agentGenre.description,
                                            storyId: "",
                                            title: "",
                                            userId: "",
                                            userName: AppData.nickname)
                
                return .run { send in
                    if let result = await storyClient.createStory(req) {
                        storyModel.storyId = result.storyId
                        await send(.moveToChatView(storyModel: storyModel))
                    }
                }

            case .tapCloseButton:
                return .none
                
            case let .sliderValueChanged(value):
                state.sliderValue = value
                return .none
                
            case let .setAgentGenre(genre):
                state.agentGenre = genre
                return .none
            
            case .moveToChatView:
                return .none
                              
            }
        }
    }
}
