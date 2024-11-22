//
//  GenreDisclosureGroup.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/17/24.
//

import SwiftUI

struct GenreDisclosureGroup: View {
    
    @State private var isExpanded: Bool = false
    @Binding var selectedOption: AgentGenreType 
    
    var body: some View {
        
        DisclosureGroup(selectedOption.description, isExpanded: $isExpanded) {
            VStack {
                ForEach(AgentGenreType.allCases, id: \.self) { option in
                    Text(option.description)
                        .font(.caption2)
                        .foregroundColor(.stYellow)
                        .onTapGesture {
                            selectedOption = option
                            isExpanded = false
                        }
                        .padding(.top, 10)
                }
            }
        }
        .font(.caption)
        .foregroundColor(.stYellow)
        .accentColor(.stYellow)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.stYellow, lineWidth: 1)
        )
        
    }
}
