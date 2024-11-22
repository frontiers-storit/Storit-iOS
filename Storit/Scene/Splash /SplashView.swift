//
//  SplashView.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/6/24.
//

import SwiftUI
import ComposableArchitecture
import FloatingButton

struct SplashView: View {
    let store : StoreOf<SplashReducer>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Image(.icLogo)
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 15)
                    
                    Spacer()
                }
               
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height)
            .background(.black)
        }
        .onAppear {
            Task {
                try? await Task.sleep(for: .milliseconds(1500)) // 1.5초
                store.send(.onApear)
            }
        }
    }
}

#Preview {
    SplashView(
        store: Store(
            initialState: SplashReducer.State(),
            reducer: { SplashReducer() }
        )
    )
}
