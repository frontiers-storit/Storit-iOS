//
//  SortOption.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/15/24.
//

import Foundation

enum SortOption: CaseIterable {
    case date
    case likes 
    
    var description: String {
        switch self {
        case .date:
            return "최신순"
        case .likes:
            return "좋아요순"
        }
    }
}
