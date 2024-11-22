//
//  BoardRequest.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/7/24.
//

import Foundation

//struct GetBoardsRequest: Encodable {
//    let page: Int
//    let limit: Int
//    let sort_by: String = "createDate"
//}

struct ReportBoardRequest: Encodable {
    let reason: String
}

struct CreateBoardRequest: Encodable {
    let storyId: String
}
