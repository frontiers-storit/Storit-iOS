//
//  BoardClient.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/7/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct BoardClient {
    var getBoards: (Int, Int) async -> GetBoardsResponse?
    var getBoard: (String) async -> BoardResponse?
    var likeBoard: (String) async -> LikeBoardResponse?
    var reportBoard: (String, ReportBoardRequest) async -> ReportBoardResponse?
    var createBoard: (CreateBoardRequest) async -> CreateBoardResponse?
}

extension BoardClient: DependencyKey {
    static var liveValue: BoardClient {
        return BoardClient(
            getBoards: { page, limit in
                return await NetworkManager.shared.request(BoardAPI.getBoards(page: page, limit: limit))
            },
            getBoard: { boardId in
                return await NetworkManager.shared.request(BoardAPI.getBoard(boardId: boardId))
            },
            likeBoard: { boardId in
                return await NetworkManager.shared.request(BoardAPI.likeBoard(boardId: boardId))
            },
            reportBoard: { boardId, req in
                return await NetworkManager.shared.request(BoardAPI.reportBoard(boardId: boardId, req: req))
            },
            createBoard: { req in
                return await NetworkManager.shared.request(BoardAPI.createBoard(req: req))
            }
        )
    }
}

extension DependencyValues {
    var boardClient: BoardClient {
        get { self[BoardClient.self] }
        set { self[BoardClient.self] = newValue }
    }
}
