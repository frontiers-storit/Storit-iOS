//
//  AMMFullVideoViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixerMediation

class AMMFullVideoViewController: UIViewController {
  
    let adUnitId: Int
    var ammVideoInterstitial: AMMVideoInterstitial!
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
        self.title = "Mediation - Video Interstitial"

        ammVideoInterstitial = AMMVideoInterstitial()
        ammVideoInterstitial.adUnitID = adUnitId
        ammVideoInterstitial.delegate = self
        ammVideoInterstitial.viewController = self
        
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
        print("tapLoadButton")
        ammVideoInterstitial.load()
    }
}

extension AMMFullVideoViewController: AMMVideoInterstitialDelegate {
    
    func onSuccessVideoInterstitial() {
        print("AMMVideoViewController - onSuccessVideoInterstitial")
    }
    
    func onFailVideoInterstitial() {
        print("AMMVideoViewController - onFailVideoInterstitial")
    }
    
    func onCloseVideoInterstitial() {
        print("AMMVideoViewController - onCloseVideoInterstitial")
    }
    
    func onTapVideoInterstitialViewMore() {
        print("AAMMVideoViewController - onTapVideoInterstitialViewMore")
    }
}


@available(iOS 13.0, *)
struct AMMFullVideoViewControllerWrapper: UIViewControllerRepresentable {
    let adUnit: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: AMMFullVideoViewController(adUnitId: adUnit))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
