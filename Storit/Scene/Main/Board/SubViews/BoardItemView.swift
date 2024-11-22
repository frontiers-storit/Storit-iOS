//
//  BoardItemView.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/10/24.
//

import SwiftUI
import ComposableArchitecture

struct BoardItemView: View {
    
    @Perception.Bindable var store: StoreOf<BoardItemReducer>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 18) {
                
                HStack {
                    Text("\(store.boardModel.title.isEmpty ? "아직 제목이 없어요. 🥺" : store.boardModel.title)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.stYellow)
                        .shadow(color: .stYellow.opacity(0.5), radius: 4, x: 0, y: 0)
                    
                    Spacer()
                }
                
                HStack {
                    Text(store.boardModel.summary.isEmpty ? "아직 생성된 스토리가 없어요" : store.boardModel.summary)
                        .lineLimit(2)
                        .font(.system(size: 12))
                        .foregroundColor(.stYellow)
                    
                    Spacer()
                }
                
                HStack {
                    Text("작가: \(store.boardModel.userName ?? "")")
                        .font(.system(size: 10))
                        .foregroundColor(.stYellow)
                    
                    Spacer()
                    
                    Text("좋아요: \(store.boardModel.likes)")
                        .font(.system(size: 10))
                        .foregroundColor(.stYellow)
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(.stGray2.opacity(0.8))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.stYellow, lineWidth: 1)
            )
        }
    }
}
