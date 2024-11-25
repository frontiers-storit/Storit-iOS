//
//  BoardResponse.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/7/24.
//

import Foundation

struct BoardResponse: Decodable {
    let isSuccess: Bool
}

struct GetBoardsResponse: Decodable {
    let boards: [BoardDTO]?
    let nextPage: Int?
    let hasNext: Bool
}

struct BoardDTO: Decodable, Equatable, Identifiable {
    let boardId: String
    let title: String
    let content: String
    let summary: String
    let views: Int
    var likes: Int
    let createDate: Int
    let userId: String
    let userName: String?
    let thumbnail: String
}

extension BoardDTO {
    var id: String {
        return self.boardId // 고유한 식별자 속성을 사용
    }
}

struct LikeBoardResponse: Decodable {
    let message: String?
}

struct ReportBoardResponse: Decodable {
    let message: String?
}

struct CreateBoardResponse: Decodable {
    let boards: [BoardDTO]?
}
