//
//  MyPageReducer.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyPageReducer {
    
    @ObservableState
    struct State : Equatable {
        var latestStories: IdentifiedArrayOf<StoryModel> = []
    }
    
    enum Action {
        case tapLogoutButton
        case tapWithdrawButton
        case getMyStories
        case moveToLogin
        case setMyStories(stories: [StoryModel])
        case tapMyStory(storyModel: StoryModel)
        case deleteAccount
    }
    
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapLogoutButton:
                return .run { send in
                    do {
                        try AuthenticationManager.shared.signOut()
                        let _ = await authClient.logout()
                        await send(.moveToLogin)
                    } catch let error {
                        print("Logout error: \(error.localizedDescription)")
                    }
                }
            case .tapWithdrawButton:
                return .none
                
            case .getMyStories:
                return .run { send in
                    do {
                        let user = try AuthenticationManager.shared.getAuthenticatedUser()
                        let stories = await FirebaseManager.shared.getMyWritingStories(uid: user.uid).map { $0.toEntity() }
                        await send(.setMyStories(stories: stories))
                    } catch let error {
                        print(" error: \(error)")
                    }
                }
            
            case let .setMyStories(stories):
                var stories = stories.sorted { $0.modifyDate > $1.modifyDate }
                if stories.count > 3 {
                    stories = Array(stories.prefix(3))
                }
                state.latestStories = IdentifiedArray(uniqueElements: stories)
                return .none
                
            case .moveToLogin:
                NotificationCenter.default.post(name: .goToLoginScreen, object: nil)
                return .none
            
            case .tapMyStory:
                return .none
                
            case .deleteAccount:
                return .run { send in
                    do {
                        try await AuthenticationManager.shared.deleteAccount()
                        // TODO: 탈퇴하기 api?
//                        let _ = await authClient.logout() // 탈퇴하기 api?
                        await send(.moveToLogin)
                    } catch let error {
                        print("Delete Account error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
