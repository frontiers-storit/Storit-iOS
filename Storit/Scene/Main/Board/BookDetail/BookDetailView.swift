//
//  BookDetailView.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/21/24.
//

import SwiftUI

struct BookDetailView: View {
    @Binding var show: Bool
    var animation: Namespace.ID
    var book: BoardDTO
    @State private var animationContent: Bool = false
    
    var body: some View {
        VStack {
            // 닫기 버튼
            Button {
                withAnimation(.easeInOut(duration: 0.35)) {
                    animationContent = false
                    show = false
                }
            } label: {
                Image(systemName: "arrow.backward")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .contentShape(Rectangle())
            }
            .padding([.leading, .vertical], 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(animationContent ? 1 : 0)
            
            // 책 내용
            GeometryReader {
                let size = $0.size
                
                HStack(spacing: 20) {
                    Image(.icMascot)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (size.width - 30) / 2, height: size.height)
//                        .clipShape(<#T##shape: Shape##Shape#>, style: <#T##FillStyle#>)
                        .matchedGeometryEffect(id: book.id, in: animation)
                }
            }
            .frame(height: 200)
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background() {
            Rectangle()
                .fill(.stBlack)
                .ignoresSafeArea()
                .opacity(animationContent ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animationContent = true
            }
        }
    }
}

//#Preview {
//    BookDetailView()
//}
