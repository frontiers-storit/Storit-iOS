//
//  AMMFullBannerViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixerMediation
import AdMixer

class AMMFullBannerViewController: UIViewController {
  
    let adUnitId: Int
    let viewType: AMFullBannerType
    var ammInterstital: AMMInterstitial!
    let loadButton = GrayButton(type: .roundedRect)
    
    init(adUnitId: Int, viewType: AMFullBannerType) {
        self.adUnitId = adUnitId
        self.viewType = viewType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mediation - 전면배너"
        
        ammInterstital = AMMInterstitial()
        ammInterstital.adUnitID = adUnitId
        ammInterstital.viewType = viewType
        ammInterstital.viewController = self
        ammInterstital.delegate = self
        ammInterstital.load()
        
        [loadButton].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        loadButton.setTitle("load ad", for: .normal)
        loadButton.addTarget(self, action: #selector(tapLoadButton), for: .touchUpInside)
        loadButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            loadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func tapLoadButton() {
        ammInterstital.load()
    }
}

extension AMMFullBannerViewController: AMMInterstitialDelegate {
    func onSuccessInterstitial() {
        print("AMMFullBannerViewController - onSucceeInterstitial")
    }
    
    func onFailInterstitial() {
        print("AMMFullBannerViewController - onFailInterstitial")
    }
}


@available(iOS 13.0, *)
struct AMMFullBannerViewControllerWrapper: UIViewControllerRepresentable {
    let adUnit: Int
    let viewType: AMFullBannerType
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: AMMFullBannerViewController(adUnitId: adUnit, viewType: viewType))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
