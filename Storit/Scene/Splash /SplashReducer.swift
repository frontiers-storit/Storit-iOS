//
//  SplashReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/6/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SplashReducer {
    
    @ObservableState
    struct State : Equatable {
        
    }
    
    enum Action {
        case onApear
        case tokenRefreshSuccess
        case tokenRefreshFailed
    }
    
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onApear :
                return .run { send in
                    do {
                        if let user = AuthenticationManager.shared.currentUser() {
                            var userType = "apple" // default

                            for provider in user.providerData {
                                if provider.providerID == "google.com" {
                                    userType = "google"
                                    break
                                } else if provider.providerID == "apple.com" {
                                    userType = "apple"
                                    break
                                }
                            }
                            
                            let token = try await AuthenticationManager.shared.getUserToken()
                            
                            Log.info("userToken: \(token)", "")
                            
                            let req = SocialLoginRequest(idToken: token, userType: userType)                            
                            
                            if let response = await authClient.socialLogin(req) {
                                if let nickname = response.userName {
                                    AppData.nickname = nickname
                                }
                                await send(.tokenRefreshSuccess)
                            }
                        } else {
                            await send(.tokenRefreshFailed)
                        }
                    } catch {
                        await send(.tokenRefreshFailed)
                    }
                }
                
            case .tokenRefreshSuccess:
                return .none
            case .tokenRefreshFailed:
                return .none
            }
        }
    }
}
