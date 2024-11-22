//
//  SocialLoginType.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/14/24.
//

import Foundation
import SwiftUI

enum SocialLoginType {
    case apple
    case google
    
    var title: String {
        switch self {
        case .apple:
            "Apple로 로그인"
        case .google:
            "Google로 로그인"
        }
    }
    
    var iconImage: Image {
        switch self {
        case .apple:
            return Image(.icAppleLogo)
        case .google:
            return Image(.icGoogleLogo)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .apple:
            return Color.white
        case .google:
            return Color.white
        }
    }
    
    var textColor: Color {
        switch self {
        case .apple:
            return Color.black
        case .google:
            return Color.black
        }
    }
}
