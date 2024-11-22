//
//  ServerType.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import Foundation

enum ServerType: CaseIterable {
    case test
    case production
    
    var title: String {
        switch self {
        case .test:
            return "개발"
        case .production:
            return "운영"
        }
    }
    
    var mediaKey: Int {
        switch self {
        case .test:
            return 24
        case .production:
            return 10068
        }
    }
    
    var adunits: Set<Int> {
        switch self {
        case .test:
            return Set([173, 175, 181, 182, 176, 178, 179, 180, 185, 187])
        case .production:
            return Set([100294, 100295, 100296, 100297, 100299, 100300, 100301, 100298])
        }
    }
}
