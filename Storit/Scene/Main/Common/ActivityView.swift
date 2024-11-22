//
//  ActivityView.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/12/24.
//

import SwiftUI
import UIKit

struct ActivityView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    public let activityItems: [Any]
    public let applicationActivities: [UIActivity]? = nil
  
    public func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
  
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        
        if isPresented && uiViewController.presentedViewController == nil {
            uiViewController.present(activityViewController, animated: true)
        }
        
        activityViewController.completionWithItemsHandler = { (_, _, _, _) in
            isPresented = false
        }
    }
}
