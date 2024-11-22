//
//  AuthRequest.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/8/24.
//

import Foundation

struct SocialLoginRequest: Encodable {
    let idToken: String
    let userType: String
}
