//
//  LoadingIndicatorView.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/25/24.
//

import Foundation
import SwiftUI
import ActivityIndicatorView

struct LoadingIndicatorView: View {
    
    @Binding var isVisible: Bool
    
    var body: some View {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
            .overlay(
                ActivityIndicatorView(
                    isVisible: $isVisible,
                    type: .rotatingDots(count: 5) //.scalingDots(count: 4, inset: 4)
                )
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(Color.stYellow)
            )
            .opacity(isVisible ? 1 : 0)
    }
}
