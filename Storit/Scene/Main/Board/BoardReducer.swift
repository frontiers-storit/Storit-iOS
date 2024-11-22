//
//  BoardReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
struct BoardReducer {
    
    @ObservableState
    struct State : Equatable {
        var boardItems: IdentifiedArrayOf<BoardItemReducer.State> = []
        var sortOption: SortOption = .date
        var currentPage: Int = 1
        var hasNextPage: Bool = true
        var isLoading: Bool = false
        var storyItems: [BoardDTO] = []
    }
    
    enum Action {
        case boardItems(IdentifiedActionOf<BoardItemReducer>)
        case tapStoryItem(BoardDTO)
        case getInitialBoards
        case getBoards
        case setBoards(GetBoardsResponse)
        case changeSortOption(SortOption)
        case loadNextPage
    }
    
    @Dependency(\.boardClient) var boardClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .boardItems(_):
                return .none
                
            case .tapStoryItem(_):
                return .none
                
            case .getInitialBoards:
                state.currentPage = 1
                state.boardItems = []
                
                return .send(.getBoards)

            case .getBoards:
                state.isLoading = true
                let page = state.currentPage
                let limit = 10
 
                return .run { send in
                    if let result = await boardClient.getBoards(page, limit) {
                        await send(.setBoards(result))
                    }
                }
                                
            case let .setBoards(result):
                state.isLoading = false
                state.hasNextPage = result.hasNext
                
                if let boards = result.boards {
                    let boardItems: [BoardItemReducer.State] = boards.map { board in
                        BoardItemReducer.State(id: UUID(), boardModel: board)
                    }
                    
                    if state.currentPage == 1 {
                        state.boardItems = IdentifiedArray(uniqueElements: boardItems)
                        state.storyItems = boards
                    } else {
                        state.boardItems.append(contentsOf: IdentifiedArray(uniqueElements: boardItems))
                    }
                    
                    if let nextPage = result.nextPage {
                        state.currentPage = nextPage
                    }
                    
                    return .send(.changeSortOption(state.sortOption))
                }
                return .none
                
            case let .changeSortOption(sortOption):
                state.sortOption = sortOption
                state.isLoading = false
                
                switch sortOption {
                case .date:
                    state.boardItems.sort {
                        $0.boardModel.createDate > $1.boardModel.createDate
                    }
                    
                case .likes:
                    state.boardItems.sort {
                        if $0.boardModel.likes == $1.boardModel.likes {
                            $0.boardModel.createDate > $1.boardModel.createDate
                        } else {
                            $0.boardModel.likes > $1.boardModel.likes
                        }
                    }
                }
                
                return .none
                
            case .loadNextPage:
                print("loadNextPage")
                
                if state.hasNextPage && !state.isLoading {
                    return .send(.getBoards)
                } else {
                    return .none
                }
            }
        }
    }
}
