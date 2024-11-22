//
//  StoritButton.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/15/24.
//

import SwiftUI

struct StoritButton: ButtonStyle {
    var labelColor = Color.stBlack
    var backgroundColor = Color.stYellow
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(labelColor)
            .opacity(configuration.isPressed ? 0.2 : 1.0)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(backgroundColor)
            .cornerRadius(8)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.stBlack)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}


