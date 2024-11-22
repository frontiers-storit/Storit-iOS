//
//  StoryComponentView.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import SwiftUI

struct StoryComponentView: View {
    let storyModel: StoryModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("\(storyModel.title.isEmpty ? "아직 제목이 없어요. 🥺" : storyModel.title) ")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.stYellow)
                
                Spacer()
            }
        
            HStack {
                Text("마지막 수정 : \(storyModel.modifyDate.formatTo())")
                    .font(.system(size: 14))
                    .foregroundColor(.stYellow)
                
                Spacer()
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(.stGray2)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.stYellow, lineWidth: 1)
        )
    }
}
