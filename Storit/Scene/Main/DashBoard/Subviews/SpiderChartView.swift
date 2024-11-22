//
//  SpiderChartView.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/20/24.
//

import SwiftUI
import UIKit

struct SpiderChartView: View {
    @State private var animatedData: [Double]
    let data: [Double]
    let labels: [String]
    let maxValues: [Double]
    let shapeColor: Color
    let frameHeight: CGFloat?
    let frameWidth: CGFloat?
    
    init(data: [Double], labels: [String], maxValues: [Double], shapeColor: Color, frameHeight: CGFloat? = nil, frameWidth: CGFloat? = nil) {
        self.data = data
        self.labels = labels
        self.maxValues = maxValues
        self.shapeColor = shapeColor
        self.frameHeight = frameHeight
        self.frameWidth = frameWidth
        
        _animatedData = State(initialValue: Array(repeating: 0, count: data.count))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SpiderChartShape(data: animatedData, maxValues: maxValues, frameSize: geometry.size, shapeColor: shapeColor)
                SpiderChartLabels(labels: labels, frameSize: geometry.size, color: shapeColor)
            }
        }
        .frame(width: frameWidth, height: frameHeight)
        .onAppear {
            animatedData = data
        }

    }
}


struct SpiderChartShape: View {
    @State var isAnimation = false
    var data: [Double]
    
    let maxValues: [Double]
    let frameSize: CGSize
    let shapeColor: Color
    
    var body: some View {
        ZStack {
            
            // spider 외곽선
            Path { path in
                let radius = min(frameSize.width, frameSize.height) / 2
                let center = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
                let angle = 2 * .pi / Double(data.count)
                
                for i in 0..<data.count {
                    let currentAngle = Double(i) * angle - .pi / 2
                    let x = center.x + CGFloat(radius * cos(currentAngle))
                    let y = center.y + CGFloat(radius * sin(currentAngle))
                    
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                path.closeSubpath()
            }
            .stroke(Color.primary.opacity(0.5), lineWidth: 2)
            
            // 중심에서 꼭지점까지 잇는 선
            let radius = min(frameSize.width, frameSize.height) / 2
            let center = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
            let angle = 2 * .pi / Double(data.count)
            ForEach(0..<data.count, id: \.self) { i in
                let currentAngle = Double(i) * angle - .pi / 2
                let x = center.x + CGFloat(radius * cos(currentAngle))
                let y = center.y + CGFloat(radius * sin(currentAngle))
                
                Path { path in
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                .stroke(Color.primary.opacity(0.5), lineWidth: 1)
            }
            
            // data 내부 색상
            SpiderChartValueShape(data: data, maxValues: maxValues)
                .fill(shapeColor.opacity(0.3))
                .opacity(isAnimation ? 1 : 0)
//                .animation(.linear(duration: 1.5), value: data)
                            
            // data 외곽선
            SpiderChartValueShape(data: data, maxValues: maxValues)
                .stroke(shapeColor.opacity(0.5), lineWidth: 2)
                .opacity(isAnimation ? 1 : 0)
//                .animation(.easeOut(duration: 1.5), value: data)
            
            // data 점
            ForEach(0..<data.count, id: \.self) { index in
                let radius = min(frameSize.width, frameSize.height) / 2
                let center = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
                let angle = 2 * .pi / Double(data.count)
                
                let currentAngle = Double(index) * angle - .pi / 2
                let currentRadius = (data[index] / maxValues[index]) * radius
                let x = center.x + CGFloat(currentRadius * cos(currentAngle))
                let y = center.y + CGFloat(currentRadius * sin(currentAngle))
                
                Circle()
                    .fill(shapeColor)
                    .frame(width: 8, height: 8)
                    .position(x: x, y: y)
                    .animation(.easeOut(duration: 1.0), value: data)
            }
        }
        .onChange(of: data) { _ in
            withAnimation(.easeIn(duration: 1.0)) {
                isAnimation = true
            }
        }
//        .onAppear {
//            withAnimation(.easeIn(duration: 1.0)) {
//                isAnimation = true
//            }
//        }
    }
}

struct SpiderChartValueShape: Shape {
    let data: [Double]
    let maxValues: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let angle = 2 * .pi / Double(data.count)
        
        for i in 0..<data.count {
            let currentAngle = Double(i) * angle - .pi / 2
            let currentRadius = (data[i] / maxValues[i]) * radius
            let x = center.x + CGFloat(currentRadius * cos(currentAngle))
            let y = center.y + CGFloat(currentRadius * sin(currentAngle))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}


struct SpiderChartLabels: View {
    let labels: [String]
    let frameSize: CGSize
    let color: Color
    
    var body: some View {
        let radius = min(frameSize.width, frameSize.height) / 2
        let angle = 2 * .pi / Double(labels.count)
        
        ForEach(0..<labels.count, id: \.self) { index in
            let currentAngle = Double(index) * angle - .pi / 2
            let x = frameSize.width / 2 + (radius + 20) * CGFloat(cos(currentAngle))
            let y = frameSize.height / 2 + (radius + 20) * CGFloat(sin(currentAngle))
            
            Text(labels[index])
                .foregroundColor(color)
                .font(.system(size: 10))
                .fontWeight(.bold)
                .position(x: x, y: y)
        }
    }
}
