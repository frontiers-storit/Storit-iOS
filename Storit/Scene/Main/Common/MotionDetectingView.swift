//
//  MotionDetectingView.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import SwiftUI

struct MotionDetectingView: UIViewControllerRepresentable {
    var onShake: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = MotionDetectingViewController()
        controller.onShake = onShake
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class MotionDetectingViewController: UIViewController {
        var onShake: (() -> Void)?
        
        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                onShake?()
            }
        }
    }
}
