//
//  AgentGenreType.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/17/24.
//

import Foundation

enum AgentGenreType: CaseIterable, Equatable {
    case anotherWorld
    case medifantasy
    case modernfantasy
    case mystery
    case highteen
    case hero
    case horror
    case martialArts
    case romance
    case zomebie
    case sf
    case timeslip
    
    var description: String {
        switch self {
        case .anotherWorld:
            return "이세계물"
        case .medifantasy:
            return "중세판타지"
        case .modernfantasy:
            return "현대판타지"
        case .mystery:
            return "추리물"
        case .highteen:
            return "하이틴"
        case .hero:
            return "히어로물"
        case .horror:
            return "공포"
        case .martialArts:
            return "무협"
        case .romance:
            return "로맨스"
        case .zomebie:
            return "좀피아포칼립스"
        case .sf:
            return "SF"
        case .timeslip:
            return "타임슬립"
        }
    }
}
