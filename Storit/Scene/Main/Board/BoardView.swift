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
    @State private var showLoadingIndicator: Bool = false
    
    private let thresholdOffset: CGFloat = 750.0

    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .center) {
                
                VStack(spacing: 20) {
                    TitleView(title: "커뮤니티")
                        .padding(.horizontal, 16)
                    
                    DropdownMenuDisclosureGroup(selectedOption: $sortOption)
                        .padding(.horizontal, 16)
                    
                    if !store.boardItems.isEmpty {
                        BookCardsView()
                    } else {
                        Spacer()
                        
                        Text("아직 게시된 스토리가 없어요 \n 스토리를 게시해 볼까요?")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.stYellow)
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 16)
                
                LoadingIndicatorView(isVisible: $showLoadingIndicator)
            }
        }
        .background(.stBlack)
        .onAppear {
            store.send(.getInitialBoards)
        }
        .onChange(of: sortOption) { _ in
            store.send(.changeSortOption(sortOption))
        }
        .onChange(of: store.state.isLoading) { isLoading in
            showLoadingIndicator = isLoading
        }
    }
    
    @ViewBuilder
    private func BookCardsView() -> some View {
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
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Image(systemName: "hand.thumbsup")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                            
                            Text(String(book.likes))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
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
                    Image(.icTestBookCover)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width / 2, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
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
        .frame(height: 180)
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
