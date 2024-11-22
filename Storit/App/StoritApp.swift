//
//  StoritApp.swift
//  Storit
//
//  Created by iOS Nasmedia on 2024/08/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseCore
import GoogleMobileAds
import FBAudienceNetwork

@main
struct StoritApp: App {
    
    init() {
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "f5aa2f2577e4060d2551d9331c901143" ]
        FBAudienceNetworkAds.initialize(with: nil, completionHandler: nil)
        FBAdSettings.setAdvertiserTrackingEnabled(true)
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(
                store: Store(
                    initialState: AppCoordinatorReducer.State(
                        routes: [.root(.splash(.init()), embedInNavigationView: true)]),
                    reducer: { AppCoordinatorReducer() }
                )
            )
        }
    }
}
