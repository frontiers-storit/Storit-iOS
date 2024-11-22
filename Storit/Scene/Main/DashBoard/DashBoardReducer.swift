//
//  DashBoardReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import ComposableArchitecture

@Reducer
struct DashBoardReducer {
    
    @ObservableState
    struct State : Equatable {
        var agentUsage: [Int] = [10, 20, 30]
        var plotAgentUsage = "0 / 100"
        var editAgentUsage = "0 / 100"
        var writeAgentUsage = "0 / 100"
    }
    
    enum Action {
        case tapCreateProjectButton
        case getAgentUsage
        case updateAgentUsage(usage: Int)
        case setAgentUsage(usage: AgentUsageResponse?)
        case tapTestAdMixerButton
    }
    
    @Dependency(\.agentClient) var agentClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapCreateProjectButton:
                return .none

            case .getAgentUsage:
                return .run { send in
                    let result = await agentClient.getAgentUsage()
                    await send(.setAgentUsage(usage: result))
                }
                
            case let .updateAgentUsage(usage):
                state.agentUsage = [usage, usage / 10, usage / 5]
                return .none
                
            case let .setAgentUsage(usage):
                var plotUsage = "0 / 100"
                var editUsage = "0 / 100"
                var writeUsage = "0 / 100"
                
                if let usage = usage {
                    plotUsage = "\(usage.plotAgent.limit - usage.plotAgent.used) / \(usage.plotAgent.limit)"
                    editUsage = "\(usage.plotAgent.limit - usage.editAgent.used) / \(usage.editAgent.limit)"
                    writeUsage = "\(usage.plotAgent.limit - usage.writeAgent.used) / \(usage.writeAgent.limit)"
                }
                
                state.plotAgentUsage = plotUsage
                state.editAgentUsage = editUsage
                state.writeAgentUsage = writeUsage
                
                return .none
                
            case .tapTestAdMixerButton:
                print("tapTestAdMixerButton")
                return .none
            }
        }
    }
}
