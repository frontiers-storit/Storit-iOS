//
//  AuthResponse.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/8/24.
//

import Foundation

struct SocialLoginResponse: Decodable {
    let id: String
    let email: String
    let token: String
    let userName: String?
}

struct LogoutResponse: Decodable {
    
}
