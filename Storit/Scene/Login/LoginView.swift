//
//  LoginView.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/6/24.
//

import SwiftUI
import AuthenticationServices
import ComposableArchitecture
import ActivityIndicatorView

struct LoginView: View {
    let store : StoreOf<LoginReducer>
    
    @State private var showLoadingIndicator: Bool = false
    
    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .top) {
                VStack {
                    Spacer()
                    
                    Image(.icLogo)
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 60)
                    
                    ZStack {
                        appleSignInButton
                            .frame(height: 40)
                            .padding(.horizontal, 16)
                        
                        loginButton(loginMethod: .apple)
                            .frame(height: 44)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                            .allowsHitTesting(false)
                    }
                    
                    loginButton(loginMethod: .google)
                        .frame(height: 44)
                        .padding(.horizontal, 16)
                        .onTapGesture(perform: {
                            store.send(.tapGoogleLoginButton)
                        })
                    
                    Spacer()
                }
                .frame(height: UIScreen.main.bounds.height)
                .background(.black)
                
                if showLoadingIndicator {
                    loadingView()
                }
            }
        }
        .onChange(of: store.state.isLoading) { isLoading in
            showLoadingIndicator = isLoading
        }
    }
    
    private var appleSignInButton: some View {
        
        SignInWithAppleButton { request in
            request.requestedScopes = [.fullName, .email]
            request.nonce = SignInAppleHelper().sha256(store.nonce)
            store.send(.showLoadingView(isLoading: true))
        } onCompletion: { result in
            
            switch result {
                
            case let .success(authResult):
                guard let credential = authResult.credential as? ASAuthorizationAppleIDCredential else { return }
                
                store.send(.appleLoginSuccess(credential))
                
            case let .failure(error):
                print(" error : \(error.localizedDescription) ")
                store.send(.showLoadingView(isLoading: false))
            }
        }
    }
    
    private func loginButton(loginMethod: SocialLoginType) -> some View {
        return HStack() {
            loginMethod.iconImage
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(loginMethod == .apple ? .black : .clear)
                .padding(.leading, 32)
                        
            Text(loginMethod.title)
                .font(.system(size: 16.0, weight: .semibold))
                .foregroundColor(loginMethod.textColor)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.trailing, 32+24)
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(loginMethod.backgroundColor)
        .cornerRadius(10)
    }
    
    private func loadingView() -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(spacing: 10) {
                    ActivityIndicatorView(
                        isVisible: $showLoadingIndicator,
                        type: .rotatingDots(count: 5) //.scalingDots(count: 4, inset: 4)
                    )
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color.stYellow)
                    .padding(.top, 20)
                    
                    Text(store.loadingText)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.stYellow)
                        .padding()
                }
                .background(.stBlack)
                .cornerRadius(10)
                .clipped()
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

#Preview {
    LoginView(
        store: Store(
            initialState: LoginReducer.State(),
            reducer: { LoginReducer() })
    )
}
