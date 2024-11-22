//
//  TitleView.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/15/24.
//

import SwiftUI

struct TitleView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.stYellow)
            
            Spacer()
        }
    }
}

#Preview {
    TitleView(title: "Storit 대시보드")
}
