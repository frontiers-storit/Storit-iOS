//
//  BoardView.swift
//  Storit
//
//  Created by iOS Nasmedia on 9/26/24.
//

import SwiftUI
import Foundation
import ComposableArchitecture

struct BoardView: View {
    var store : StoreOf<BoardReducer>
    
    @State private var sortOption: SortOption = .date
    private let thresholdOffset: CGFloat = 750.0
    
    @Namespace private var animation
    @State private var showDetailView: Bool = false
    @State var selectedBook: BoardDTO? = nil
    @State private var animateCurrentBook: Bool = false

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 20) {
                TitleView(title: "커뮤니티")
                    .padding(.horizontal, 16)
                
                DropdownMenuDisclosureGroup(selectedOption: $sortOption)
                    .padding(.horizontal, 16)
              
                if !store.boardItems.isEmpty {
//                        ScrollView(showsIndicators: false) {
//                            LazyVStack {
//                                ForEach(
//                                    store.scope(state: \.boardItems, action: \.boardItems)
//                                ) { item in
//                                    BoardItemView(store: item)
//                                        .padding(.bottom, 10)
//                                        .onTapGesture {
//                                            store.send(.tapStoryItem(item.boardModel))
//                                        }
//                                }
//                            }
//                            .background(
//                                GeometryReader { geo -> Color in
//                                    let maxoffset = geo.frame(in: .global).maxY
//                                    
//                                    DispatchQueue.main.async {
//                                        if maxoffset < thresholdOffset {
//                                            store.send(.loadNextPage)
//                                        }
//                                    }
//                                    
//                                    return Color.clear
//                                }
//                            )
//                        }
                    newBookView()
                } else {
                    Spacer()
                    
                    Text("아직 게시된 스토리가 없어요 \n 스토리를 게시해 볼까요?")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.stYellow)
                    
                    Spacer()
                }
            }
            .padding(.vertical, 16)
            .background(.stBlack)
            .onAppear {
                store.send(.getInitialBoards)
            }
            .onChange(of: sortOption) { _ in
                store.send(.changeSortOption(sortOption))
            }
            .overlay {
                if let selectedBook, showDetailView {
                    BookDetailView(show: $showDetailView,
                                   animation: animation,
                                   book: selectedBook)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
                }
            }
            .onChange(of: showDetailView) { newValue in
                if !newValue {
                    withAnimation(.easeInOut(duration: 0.15).delay(0.3)) {
                        animateCurrentBook = false
                    }
                }
            }
        }
    }
    
    private func newBookView() -> some View {
        GeometryReader {
            let size = $0.size
                        
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 35) {
                    ForEach(store.storyItems, id: \.id) { story in
                        BookCardView(story)
                            .onTapGesture { store.send(.tapStoryItem(story)) }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 20)
                .padding(.bottom, bottomPadding(size))
                .background(
                    GeometryReader { geo -> Color in
                        let maxoffset = geo.frame(in: .global).maxY
                        DispatchQueue.main.async {
                            if maxoffset < thresholdOffset {
                                store.send(.loadNextPage)
                            }
                        }
                        return Color.clear
                    }
                )
            }
            .coordinateSpace(name: "SCROLLVIEW")
        }
        .padding(.top, 15)
    }
    
    @ViewBuilder
    func BookCardView(_ book: BoardDTO) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
                        
            HStack(spacing: -25) {
                
                // Book Detail
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        Text(book.title)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.stYellow)
                            .shadow(color: .stYellow.opacity(0.5), radius: 4, x: 0, y: 0)
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    HStack {
                        Text("By \(book.userName ?? "")")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("좋아요: \(book.likes)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text(book.summary)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(10)
                .frame(width: size.width / 2, height: size.height*0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.stGray1)
//                        .shadow(color: .white.opacity(0.5), radius: 5, x: 0, y: 0)
//                        .shadow(color: .white.opacity(0.2), radius: 3, x: 5, y: 5)
//                        .shadow(color: .white.opacity(0.2), radius: 3, x: -5, y: -5)
                }
                .zIndex(1)
                
                // Book cover image
                ZStack {
                    if !(showDetailView) {
                        Image(.icMascot)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width / 2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
//                            .shadow(color: .white.opacity(0.2), radius: 3, x: -5, y: -5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
            .rotation3DEffect(.init(
                degrees: convertOffsetToRotation(rect)),
                              axis: (x: 1, y: 0, z: 0),
                              anchor: .bottom,
                              anchorZ: 1,
                              perspective: 0.8
            )
        }
        .frame(height: 200)
    }
    
    func convertOffsetToRotation(_ rect: CGRect) -> Double {
        let cardHeight = rect.height + 20
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cardHeight) : 0
        let constrainedProgress = min(-progress, 1.0)
        
        return constrainedProgress * 90.0
    }
    
    func bottomPadding(_ size: CGSize = .zero) -> CGFloat {
        let cardHeight: CGFloat = 200
        let scrollViewHeight: CGFloat = size.height
        
        return scrollViewHeight - cardHeight - 40
    }
    
}

//#Preview {
//    BoardView(
//        store: Store(
//            initialState: BoardReducer.State(),
//            reducer: { BoardReducer() })
//    )
//}
