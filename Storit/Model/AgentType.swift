//
//  AgentType.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import Foundation
import SwiftUI

enum AgentType: CaseIterable {
    case plot
    case edit
    case write
    case none
    
    var name: String {
        switch self {
        case .plot:
            return "플롯 AI"
        case .edit:
            return "첨삭 AI"
        case .write:
            return "전개 AI"
        case .none:
            return "AI 에이전트"
        }
    }
    
    var detailedTitle: String {
        switch self {
        case .plot:
            return "플롯 구성 에이전트"
        case .edit:
            return "문장 작성 에이전트"
        case .write:
            return "서사 이음 에이전트"
        case .none:
            return "AI 에이전트"
        }
    }
    
    var iconImage: Image {
        switch self {
        case .plot:
            return Image(.icPlot)
        case .edit:
            return Image(.icEdit)
        case .write:
            return Image(.icWrite)
        case .none:
            return Image(.icMascot)
        }
    }
    
    var mascotImage: Image {
        switch self {
        case .plot:
            return Image(.icMascotPlot)
        case .edit:
            return Image(.icMascotEdit)
        case .write:
            return Image(.icMascotWrite)
        case .none:
            return Image(.icMascot)
        }
    }
}
