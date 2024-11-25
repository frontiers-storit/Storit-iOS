//
//  MainView.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import SwiftUI
import ComposableArchitecture

struct DashBoardView: View {
    let store : StoreOf<DashBoardReducer>
    let screenWidth = UIScreen.main.bounds.width
    
    @State private var isAdmixerButtonVisible = false
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                
                HStack {
                    Spacer()
                    
                    Image(.icNoTextLogo)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.bottom, 5)
                    
                    Spacer()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        TitleView(title: "STORIT AI STATS")
                                                
                        spiderView()
                            .padding(.bottom, 5)
                        
                        HStack {
                            agentView(agentType: .plot, usage: store.agentUsage[0])
                            Spacer()
                            agentView(agentType: .edit, usage: store.agentUsage[1])
                            Spacer()
                            agentView(agentType: .write, usage: store.agentUsage[2])
                        }
                        
                        Button(action: {
                            store.send(.tapCreateProjectButton)
                        }, label: {
                            Text("새 스토리 만들기")
                        })
                        .buttonStyle(StoritButton())
                        
                        if isAdmixerButtonVisible {
                            Button(action: {
                                store.send(.tapTestAdMixerButton)
                            }, label: {
                                Text("AdMixerTest")
                            })
                            .buttonStyle(StoritButton())
                        }
                                                
                        bannerView()
                    }
                    .padding(.horizontal, 16)
                }
                .background(.stBlack)
                .scrollBounceBehavior(.basedOnSize)
            }
            .background(.stBlack)
            .scrollBounceBehavior(.basedOnSize)
        }
        .onAppear {
            store.send(.getAgentUsage)
        }
        .overlay {
            MotionDetectingView {
                // 모션 이벤트가 발생했을 때 버튼 표시
                withAnimation {
                    isAdmixerButtonVisible.toggle()
                }
            }
            .allowsHitTesting(false)
        }
    }
    
    private func spiderView() -> some View {
        HStack(spacing: 40) {
            Image(.icMascotNothing)
                .resizable()
                .frame(width: 110, height: 110)
                .cornerRadius(115)
                .padding(.leading, 16)
                .shadow(
                    color: .white.opacity(0.8),
                    radius: CGFloat(10),
                    x: CGFloat(0),
                    y: CGFloat(0)
                )
            
            let data: [Double] = [3,2,2,3,2]
            let labels: [String] = ["창의력", "문장력", "공감력", "구성력", "집중력"]
            let maxValues: [Double] = [3, 3, 3, 3, 3]
            let shapeColor: Color = Color.stYellow
            
            SpiderChartView(
                data: data,
                labels: labels,
                maxValues: maxValues,
                shapeColor: shapeColor
            )
            .frame(height: 160)
            
            Spacer()
        }
        .padding(.vertical, 32)
        .background(.stGray1)
        .cornerRadius(10)
        .shadow(
            color: .white.opacity(0.8),
            radius: CGFloat(5),
            x: CGFloat(0),
            y: CGFloat(0)
        )
        
    }
    
    private func agentView(agentType: AgentType, usage: Int) -> some View {
        VStack(spacing: 12) {
            
            agentType.iconImage
                .resizable()
                .frame(
                    width: (screenWidth - 16*2 - 16*2) / 3 - 16*2,
                    height: (screenWidth - 16*2 - 16*2) / 3 - 16*2)
                .cornerRadius(12)
                .shadow(
                    color: .white.opacity(0.8),
                    radius: CGFloat(3),
                    x: CGFloat(0),
                    y: CGFloat(0)
                )
                
            Text(agentType.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.stYellow)
                
            switch agentType {
            case .plot:
                Text(store.plotAgentUsage)
                    .font(.system(size: 12))
                    .foregroundColor(.stYellow)
            case .edit:
                Text(store.editAgentUsage)
                    .font(.system(size: 12))
                    .foregroundColor(.stYellow)
            default:
                Text(store.writeAgentUsage)
                    .font(.system(size: 12))
                    .foregroundColor(.stYellow)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(.stGray1)
        .cornerRadius(10)
        .shadow(
            color: .white.opacity(0.7),
            radius: CGFloat(3),
            x: CGFloat(0),
            y: CGFloat(0)
        )
    }
    
    private func projectView(project: StoryModel) -> some View {
        VStack(spacing: 18) {
            HStack {
                Text("project.title")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.stYellow)
                
                Spacer()
            }
            
            HStack {
                Text("마지막 수정 : \(project.modifyDate)")
                    .font(.system(size: 12))
                    .foregroundColor(.stYellow)
                
                Spacer()
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(.stGray1)
        .cornerRadius(10)
    }
    
    private func bannerView() -> some View {
        AdMixerBannerView()
            .frame(width: 350, height: 100)
    }
}

#Preview {
    DashBoardView(
        store: Store(
            initialState: DashBoardReducer.State(),
            reducer: { DashBoardReducer() })
    )
}
