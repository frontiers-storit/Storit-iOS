//
//  AuthClient.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/8/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct AuthClient {
    var socialLogin: (SocialLoginRequest) async -> SocialLoginResponse?
    var logout: () async -> LogoutResponse?
}

extension AuthClient: DependencyKey {
    static var liveValue: AuthClient {
        return AuthClient(
            socialLogin: { req in
                return await NetworkManager.shared.request(AuthAPI.socialLogin(req: req))
            },
            logout: {
                return await NetworkManager.shared.request(AuthAPI.logout)
            }
        )
    }
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
