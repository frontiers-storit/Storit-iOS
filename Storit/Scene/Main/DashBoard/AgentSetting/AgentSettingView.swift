//
//  AgentSettingView.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/17/24.
//

import SwiftUI
import ComposableArchitecture

struct AgentSettingView: View {
    var store: StoreOf<AgentSettingReducer>
    
    @State private var sliderValue = 5.0
    @State private var agentGenre: AgentGenreType = .sf
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            store.send(.tapCloseButton)
                        }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .accentColor(.stYellow)
                                .foregroundColor(.stYellow)
                                .frame(width: 12, height: 12)
                        })
                    }
                    .padding(.bottom, 20)
                    
                    Image(.icNoTextLogo)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .background(.black)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.stYellow, lineWidth: 2)
                                .shadow(
                                    color: .white.opacity(0.8),
                                    radius: CGFloat(5),
                                    x: CGFloat(0),
                                    y: CGFloat(0)
                                )
                        )
                        .padding(.bottom, 20)
                    
                    Text("에이전트 설정")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.stYellow)
                        .padding(.bottom, 20)
                    
                    Text("에이전트는 창의적인 플롯 구성을 도와드립니다. 장르에 맞는 구조와 전개를 제안하고, 흥미로운 반전을 만들어냅니다.")
                        .font(.caption)
                        .foregroundColor(.stYellow)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Text("설정")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.stYellow)
                        
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("선호 장르")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.stYellow)
                        
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    GenreDisclosureGroup(selectedOption: $agentGenre)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Text("창의성 수준")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.stYellow)
                        
                        Text("\(Int(sliderValue))")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.stYellow)
                        
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    Slider(value: $sliderValue, in: 0...10, step: 1) {
                      Text("Title")
                    } minimumValueLabel: {
                        Text("0")
                              .foregroundColor(.stYellow)
                    } maximumValueLabel: {
                        Text("10")
                              .foregroundColor(.stYellow)
                    } onEditingChanged: { _ in
                        store.send(.sliderValueChanged(sliderValue))
                    }
                    .accentColor(.stYellow)
                    .padding(.bottom, 20)
                    
                    Button {
                        store.send(.tapStartButton)
                    } label: {
                        Text("시작하기")
                    }
                    .buttonStyle(StoritButton())
                    
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(.stGray1)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .background(.stBlack)
            .onChange(of: agentGenre) { _ in
                store.send(.setAgentGenre(agentGenre))
            }
        }
    }
}

#Preview {
    AgentSettingView(
        store: Store(
            initialState: AgentSettingReducer.State(),
            reducer: { AgentSettingReducer() })
    )
}
