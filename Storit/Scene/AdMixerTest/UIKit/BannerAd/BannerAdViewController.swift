//
//  BannerAdViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixer

class BannerAdViewController: UIViewController {

    let adInfo: AMBannerAdInfo
    let bannerAdView: AMBannerAdView!
    let buttonStack = UIStackView()
    
    init(adInfo: AMBannerAdInfo) {
        self.adInfo = adInfo
        self.bannerAdView = AMBannerAdView(adInfo: adInfo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AdMixer - Banner"
        setLayout()
    }
}

extension BannerAdViewController {
    func setLayout() {
        [bannerAdView, buttonStack].forEach {
            self.view.addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
      
        NSLayoutConstraint.activate([
            self.bannerAdView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.bannerAdView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            self.bannerAdView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.bannerAdView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.buttonStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.buttonStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonStack.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        let loadButton = GrayButton(type: .roundedRect)
        let loadHButton = GrayButton(type: .roundedRect)
        let showButton = GrayButton(type: .roundedRect)
        
        [loadButton, loadHButton, showButton].forEach {
            buttonStack.addArrangedSubview($0)
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        }
        
        loadButton.setTitle("load ad", for: .normal)
        loadButton.addTarget(self, action: #selector(tapLoadButton), for: .touchUpInside)
        loadHButton.setTitle("load house ad", for: .normal)
        loadHButton.addTarget(self, action: #selector(tapLoadHouseButton), for: .touchUpInside)
        showButton.setTitle("show", for: .normal)
        showButton.addTarget(self, action: #selector(tapShowButton), for: .touchUpInside)

        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.spacing = 15
        buttonStack.backgroundColor = .white
    }
   
    @objc func tapLoadButton() {
        self.bannerAdView.loadAd()
    }
    
    @objc func tapLoadHouseButton() {
        self.bannerAdView.loadHouseAd()
    }
    
    @objc func tapShowButton() {
        self.bannerAdView.showAd()
    }
}

@available(iOS 13.0, *)
struct BannerAdViewControllerWrapper: UIViewControllerRepresentable {
    let adInfo: AMBannerAdInfo
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: BannerAdViewController(adInfo: self.adInfo))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
