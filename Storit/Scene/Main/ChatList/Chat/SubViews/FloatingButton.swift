//
//  FloatingButton.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/1/24.
//

import Foundation
import SwiftUI

struct MainFloatingButton: View {

    var image: Image
    var color: Color
    var width: CGFloat = 50

    var body: some View {
        ZStack {
            color
                .frame(width: width, height: width)
                .cornerRadius(width / 2)
                .shadow(color: color.opacity(0.3), radius: 15, x: 0, y: 15)
            image
                .foregroundColor(.white)
        }
        .frame(width: width, height: width)
    }
}


struct IconAndTextButton: View {
    var image: Image
    var buttonText: String
    let imageWidth: CGFloat = 45

    var body: some View {
        HStack {
            Spacer()
            
            Text(buttonText)
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(Color.stYellow)
            
            image
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .foregroundColor(Color.stYellow)
                .frame(width: imageWidth, height: imageWidth)
                .clipped()
        }
        .frame(width: 200, height: 45)
    }
}

struct IconButton: View {

    var image: Image
    var color: Color
    let imageWidth: CGFloat = 45
    let buttonWidth: CGFloat = 45

    var body: some View {
        ZStack {
            color
            
            image
                .resizable()
                .frame(width: imageWidth, height: imageWidth)
                .foregroundColor(.white)
        }
        .frame(width: buttonWidth, height: buttonWidth)
        .cornerRadius(buttonWidth / 2)
        .overlay(
            RoundedRectangle(cornerRadius: (buttonWidth / 2))
                .stroke(Color.stYellow, lineWidth: 1)
        )
    }
}
