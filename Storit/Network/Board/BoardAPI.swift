//
//  BoardAPI.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/7/24.
//

import Foundation
import Alamofire

enum BoardAPI {
    case getBoards(page: Int, limit: Int)
    case getBoard(boardId: String)
    case likeBoard(boardId: String)
    case reportBoard(boardId: String, req: ReportBoardRequest)
    case createBoard(req: CreateBoardRequest)
    case getMyBoards
}

extension BoardAPI: EndPoint {
    
    var baseURL: String {
        return "https://storit-api-909260373550.asia-northeast3.run.app"
    }
    
    var path: String {
        switch self {
        case let .getBoards(page, limit):
            return "/api/v1/boards/?page=\(page)&limit=\(limit)"
        case let .getBoard(boardId):
            return "/api/v1/boards/\(boardId)"
        case let .likeBoard(boardId):
            return "/api/v1/boards/\(boardId)/like"
        case let .reportBoard(boardId, _):
            return "/api/v1/boards/\(boardId)/report"
        case .createBoard:
            return "/api/v1/boards/"
        case .getMyBoards:
            return "/api/v1/boards/my/written"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBoards:
            return .get
        case .getBoard:
            return .get
        case .likeBoard:
            return .post
        case .reportBoard:
            return .post
        case .createBoard:
            return .post
        case .getMyBoards:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case .getBoards:
            return .requestPlain
        case .getBoard:
            return .requestPlain
        case .likeBoard:
            return .requestPlain
        case let .reportBoard(_, body):
            return .requestBody(body: body)
        case let .createBoard(body):
            return .requestBody(body: body)
        case .getMyBoards:
            return .requestPlain
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        default:
            let token = AuthenticationManager.shared.userToken ?? ""
            
            return["Authorization": "Bearer \(token)",
                   "Content-Type": "application/json"]
        }
    }
}
