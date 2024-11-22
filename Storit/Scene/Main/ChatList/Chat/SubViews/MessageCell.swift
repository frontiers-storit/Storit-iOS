//
//  MessageCell.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/18/24.
//

import SwiftUI

struct MessageCell: View {
    let message: String
    let isCurrentUser: Bool
    
    var body: some View {
        if isCurrentUser {
            HStack {
                Spacer()
                
                Text(message)
                    .padding(10)
                    .foregroundColor(isCurrentUser ? .stBlack : .stYellow)
                    .background(isCurrentUser ? .stYellow : .stGray2)
                    .cornerRadius(18)
            }
            .padding(.trailing, 10)
        } else {
            HStack {
                Text(message.replacingOccurrences(of: "\\n", with: "\n"))
                    .padding(10)
                    .foregroundColor(isCurrentUser ? .stBlack : .stYellow)
                    .background(isCurrentUser ? .stYellow : .stGray2)
                    .cornerRadius(18)
                
                Spacer()
            }
            .padding(.leading, 10)
        }
    }
}

#Preview {
    MessageCell(message: "This is message cellThis is message cellThis is message cell",
                isCurrentUser: false)
}
