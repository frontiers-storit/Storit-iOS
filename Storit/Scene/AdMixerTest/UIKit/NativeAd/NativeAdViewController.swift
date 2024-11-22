//
//  NativeAdViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixer

class NativeAdViewController: UIViewController {
    
    let adInfo: AMNativeAdInfo
    var nativeView: AMNativeAdView!
    let loadButton = GrayButton(type: .roundedRect)
    
    init(adInfo: AMNativeAdInfo) {
        self.adInfo = adInfo
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AdMixer - Native"
        
        [loadButton].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        loadButton.setTitle("load ad", for: .normal)
        loadButton.addTarget(self, action: #selector(loadNativeAd), for: .touchUpInside)
        loadButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            loadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            loadButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func loadNativeAd() {
        
        let nibView = Bundle.main.loadNibNamed("NativeView", owner: nil, options: nil)?.first
        nativeView = nibView as? AMNativeAdView
        
        nativeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nativeView)
        NSLayoutConstraint.activate([
            nativeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nativeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nativeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        nativeView.adInfo = adInfo
        nativeView.delegate = self
        
        nativeView.loadAd()
    }
}

extension NativeAdViewController: AMNativeAdDelegate {
    func didLoadNativeAdSuccess(amNative: AMNative) {
        nativeView.iconImage = amNative.icon
        nativeView.l_headline.text = amNative.title
        nativeView.l_advertiser.text = amNative.advertiser
        nativeView.l_description.text = amNative.descriptionText
        nativeView.amv_media.image = amNative.image
        nativeView.amv_media.video = amNative.video
    }
    
    func didLoadNativeAdFail(with error: Error?) {
        print("AMNativeAdDelegate - didLoadNativeAdFail : \(error?.localizedDescription)")
    }
    
    func didShowNativeAdSuccess() {
        print("AMNativeAdDelegate - didShowNativeAdSuccess")
    }
}

@available(iOS 13.0, *)
struct NativeAdViewControllerWrapper: UIViewControllerRepresentable {
    let adInfo: AMNativeAdInfo
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: NativeAdViewController(adInfo: adInfo))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
