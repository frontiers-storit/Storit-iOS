//
//  View+.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/13/24.
//

import SwiftUI
import AlertToast

extension View {
    func alertToastView(title: String) -> AlertToast {
        AlertToast(
            displayMode: .banner(.pop),
            type: .regular,
            title: title,
            style: .style(
                backgroundColor: .stYellow.opacity(0.8),
                titleColor: .stGray1,
                subTitleColor: nil,
                titleFont: .caption,
                subTitleFont: nil)
        )
    }
}
