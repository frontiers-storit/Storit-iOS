//
//  AuthenticationManager.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/6/24.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager: NSObject {
    
    let auth: Auth
    public var userToken: String?
    
    static let shared = AuthenticationManager()
    
    override init() {
        self.auth = Auth.auth()
        
        super.init()
    }
    
    func currentUser() -> User? {
        return auth.currentUser
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = currentUser() else {
            throw URLError(.badServerResponse)
        }

        return AuthDataResultModel(user: user)
    }
    
    func getUserName() -> String {
        return currentUser()?.displayName ?? "비공개 사용자"
    }
    
    func getUserEmail() -> String {
        return currentUser()?.email ?? ""
    }
   
    func getUserToken() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            currentUser()?.getIDToken { idToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let idToken = idToken {
                    self.userToken = idToken
                    continuation.resume(returning: idToken)
                } else {
                    continuation.resume(returning: "")
                }
            }
        }
    }
    
    // MARK: 로그인
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await auth.signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // MARK: 로그아웃
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: 계정 탈퇴
    func deleteAccount() async throws {
        // 유저 데이터 삭제
        do {
            let currentUser = Auth.auth().currentUser
            try await FirebaseManager.shared.deleteUserData(uid: currentUser?.uid ?? "")
            try await currentUser?.delete()
        } catch let error {
            print("deleteAccount error : \(error.localizedDescription)")
        }
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = auth.currentUser?.providerData else {
            throw URLError(.badURL)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("provider option not found : \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let firebaseCredential = OAuthProvider.credential(providerID: .apple, idToken: tokens.token, rawNonce: tokens.nonce)
        return try await signIn(credential: firebaseCredential)
    }
}

enum AuthProviderOption: String {
    case google = "google.com"
    case apple = "apple.com"
}
