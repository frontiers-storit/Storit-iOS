//
//  AMMNativeAdViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixerMediation

class AMMNativeAdViewController: UIViewController {
  
    let adUnitId: Int
    var nativeView: AMMNativeAdViewContainer!
    let loadButton = GrayButton(type: .roundedRect)
    
    init(adUnitId: Int) {
        self.adUnitId = adUnitId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mediation - Native"
        
        let nibView = Bundle.main.loadNibNamed("AMMNativeView", owner: nil, options: nil)?.first
        let nativeAdView = nibView as? AMMNativeAdView
        
        nativeView = AMMNativeAdViewContainer()
        nativeView.nativeAdView = nativeAdView
        
        [loadButton, nativeView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        loadButton.setTitle("load ad", for: .normal)
        loadButton.addTarget(self, action: #selector(loadNativeAd), for: .touchUpInside)
        loadButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            loadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadButton.heightAnchor.constraint(equalToConstant: 40),
            
            nativeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nativeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nativeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func loadNativeAd() {
        print("loadNativeAd")
        nativeView.adUnitID = adUnitId
        nativeView.viewController = self
        nativeView.delegate = self
        nativeView.load()
    }
}

extension AMMNativeAdViewController: AMMNativeDelegate {
    func onSuccessNative() {
        print("AMMNativeDelegate - onSuccessNative")
    }
    
    func onFailNative() {
        print("AMMNativeDelegate - onFailNative")
    }
}

@available(iOS 13.0, *)
struct AMMNativeAdViewControllerWrapper: UIViewControllerRepresentable {
    let adUnitID: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: AMMNativeAdViewController(adUnitId: adUnitID))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
