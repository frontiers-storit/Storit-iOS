//
//  LoginReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/6/24.
//

import Foundation
import AuthenticationServices
import ComposableArchitecture
import GoogleSignIn
import Firebase
import FirebaseAuth

@Reducer
struct LoginReducer {
    
    @ObservableState
    struct State : Equatable {
        var nonce: String = SignInAppleHelper().randomNonceString()
        var isLoading: Bool = false
        let loadingText: String = ["판타지 주인공과 로맨스 준비중..", "전설 속의 용 소환하는 중..", "이세계로 전생하는 중.."].randomElement()!
    }
    
    enum Action {
        case goToMain
        case appleLoginSuccess(ASAuthorizationAppleIDCredential)
        case tapGoogleLoginButton
        case googleLoginSuccess(GIDGoogleUser)
        case showLoadingView(isLoading: Bool)
    }
    
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .goToMain:
                return .none
            
            case let .appleLoginSuccess(credential):
                let nonce = state.nonce
                
                return .run { send in
                    guard let idToken = credential.identityToken,
                          let idTokenString = String(data: idToken, encoding: .utf8) else {
                        return
                    }
                    
                    print("token : \(idTokenString)")
                    
                    let tokens = SignInWithAppleResult(
                        token: idTokenString,
                        nonce: nonce,
                        userName: credential.fullName?.givenName,
                        email: credential.email)
                    
                    do {
                        
                        // Firebase-apple login
                        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
                        
                        // Firebase JWT Token
                        let token = try await AuthenticationManager.shared.getUserToken()
                        
                        let req = SocialLoginRequest(idToken: token, userType: "apple")
                       
                        if let response = await authClient.socialLogin(req) {
                            if let nickname = response.userName {
                                AppData.nickname = nickname
                            }
                            // Move To Main
                            await send(.showLoadingView(isLoading: false))
                            await send(.goToMain)
                        }
                                                
                    } catch let (error) {
                        // Fail: Firebase-apple login
                        print("error: \(error)")
                        await send(.showLoadingView(isLoading: false))
                    }
                }
                
            case .tapGoogleLoginButton:
                state.isLoading = true
                return .run { send in
                    if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                        do {
                            let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
                            await send(.googleLoginSuccess(user))
                        } catch let error {
                            print("GIDSignIn error : \(error.localizedDescription)")
                        }
                    } else {
                        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                        let configuration = GIDConfiguration(clientID: clientID)
                        GIDSignIn.sharedInstance.configuration = configuration
                        
                        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let rootVC = await windowScene.windows.first?.rootViewController else { return }
                        
                        do {
                            let user = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
                            await send(.googleLoginSuccess(user.user))
                        } catch let error {
                            print("GIDSignIn error: \(error.localizedDescription) ")
                        }
                    }
                }
                                    
            case let .googleLoginSuccess(user):
                return .run { send in
                    guard let idToken = user.idToken?.tokenString else { return }
                    
                    let accessToken = user.accessToken.tokenString
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                    
                    do {
                        let _ = try await AuthenticationManager.shared.signIn(credential: credential)

                        // Firebase JWT Token
                        let token = try await AuthenticationManager.shared.getUserToken()
                        
                        print("token: \(token)")

                        let req = SocialLoginRequest(idToken: token, userType: "google")
                        
                        if let response = await authClient.socialLogin(req) {
                            if let nickname = response.userName {
                                AppData.nickname = nickname
                            }
                            // Move To Main
                            await send(.showLoadingView(isLoading: false))
                            await send(.goToMain)
                        }
                    } catch let error {
                        print(" google login error: \(error.localizedDescription)")
                        await send(.showLoadingView(isLoading: false))
                    }
                }
                
            case let .showLoadingView(isLoading):
                state.isLoading = isLoading
                return .none
            }
        }
    }
}
