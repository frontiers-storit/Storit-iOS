//
//  ChatItemView.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/11/24.
//

import SwiftUI
import ComposableArchitecture

struct ChatItemView: View {
    
    @Perception.Bindable var store: StoreOf<ChatItemReducer>
    
    let showStoryButtonAction: (() -> ())?
    let deleteStoryButtonAction: (() -> ())?

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 18) {
                
                HStack {
                    Text("\(store.storyModel.title.isEmpty ? "아직 제목이 없어요. 🥺" : store.storyModel.title)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.stYellow)
                        .shadow(color: .stYellow.opacity(0.5), radius: 4, x: 0, y: 0)
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            deleteStoryButtonAction?()
                        }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .accentColor(.stYellow)
                                .foregroundColor(.stYellow)
                                .shadow(color: .stYellow.opacity(0.5), radius: 4, x: 0, y: 0)
                                .frame(width: 12, height: 12)
                        })
                        
                        Spacer()
                    }
                    
                }
                
                HStack {
                    VStack(spacing: 3) {
                        HStack {
                            Text("마지막 수정: \(store.storyModel.modifyDate.formatTo())")
                                .font(.system(size: 12))
                                .foregroundColor(.stYellow)
                            
                            Spacer()
                        }
                    
                        HStack {
                            Text(store.storyModel.isCompleted ? "작성완료" : "작성중")
                                .font(.system(size: 12))
                                .foregroundColor(.stYellow)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    if store.storyModel.isCompleted {
                        Button(action: {
                            showStoryButtonAction?()
                        }, label: {
                            Text("작품 미리보기")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.stBlack)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 5)
                                .shadow(color: .stBlack.opacity(0.8), radius: 6, x: 0, y: 2)
                        })
                        .background(.stYellow)
                        .cornerRadius(6)
                    }
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(.stGray1)
            .cornerRadius(10)
        }
    }
}

//
//#Preview {
//    ChatItemView(
//        store: Store(
//            initialState: ChatItemReducer.State(),
//            reducer: { ChatItemReducer() })
//    )
//}
