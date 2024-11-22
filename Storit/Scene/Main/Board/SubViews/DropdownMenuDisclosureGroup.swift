//
//  DropdownMenuDisclosureGroup.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/10/24.
//

import SwiftUI

struct DropdownMenuDisclosureGroup: View {
    
    @State private var isExpanded: Bool = false
    @Binding var selectedOption: SortOption
    
    var body: some View {
        
        DisclosureGroup(selectedOption.description, isExpanded: $isExpanded) {
            VStack {
                ForEach(SortOption.allCases, id: \.self) { option in
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
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.stYellow, lineWidth: 1)
        )
        
    }
}
//
//#Preview {
//    DropdownMenuDisclosureGroup(selectedOption: .date)
//}
