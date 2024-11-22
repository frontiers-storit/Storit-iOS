//
//  AdType.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import Foundation

enum AdType {
    case banner
    case fullBanner
    case instreamVideo
    case fullVideo
    case rewardVideo
    case native

    var title: String {
        switch self {
        case .banner:
            return "일반 배너"
        case .fullBanner:
            return "전면 배너"
        case .instreamVideo:
            return "일반 비디오"
        case .fullVideo:
            return "전면 비디오"
        case .rewardVideo:
            return "리워드 비디오"
        case .native:
            return "네이티브"
        }
    }
    
    var isMediationEnabled: Bool {
        switch self {
        case .banner:
            return true
        case .fullBanner:
            return true
        case .instreamVideo:
            return true
        case .fullVideo:
            return true
        case .rewardVideo:
            return true
        case .native:
            return true
        }
    }
    
    var testAdUnits: [Int: String]? {
        switch self {
        case .banner:
            return [
                181: "320x50",
                182: "320x480",
                175: "320x100",
                173: "300x250"
            ]
        case .fullBanner:
            return [
                176: "320x50",
                179: "320x480",
                178: "320x100",
                180: "300x250"
            ]

        case .instreamVideo:
            return [
                186: "",
            ]
        case .fullVideo:
            return [
                184: "",
            ]
        case .rewardVideo:
            return [
                185: ""
            ]
        case .native:
            return [
                187: ""
            ]
        }
    }
    
    var prodAdUnits: [Int: String]? {
        switch self {
        case .banner:
            return [
                100294: "320x50",
                100295: "320x100",
                100296: "300x250",
                100297: "320x480",
            ]
        case .fullBanner:
            return [
                100299: "300x250",
                100300: "320x480",
            ]
        case .instreamVideo:
            return [:]
            
        case .fullVideo:
            return [:]
            
        case .rewardVideo:
            return [
                100301: ""
            ]
        case .native:
            return [
                100298: ""
            ]
        }
    }
}
