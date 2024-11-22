//
//  VideoAdViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixer

class VideoAdViewController: UIViewController {
    
    let adInfo: AMVideoAdInfo
    let videoAdView: AMVideoAdView!
    let mediaView = UIView()
    let buttonStack = UIStackView()
    
    init(adInfo: AMVideoAdInfo) {
        self.adInfo = adInfo
        self.videoAdView = AMVideoAdView(adInfo: adInfo)
        super.init(nibName: nil, bundle: nil)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AdMixer - Instream Video"
    }
}

extension VideoAdViewController {
    func setLayout() {
        [mediaView, videoAdView, buttonStack].forEach {
            self.view.addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        mediaView.backgroundColor = .blue.withAlphaComponent(0.5)
        
        let label = UILabel()
        label.text = "매체사 비디오 영역입니다."
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        mediaView.addSubview(label)
        
        NSLayoutConstraint.activate([
            self.mediaView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.mediaView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            self.mediaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mediaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.mediaView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: mediaView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: mediaView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.buttonStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.buttonStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonStack.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        let loadButton = GrayButton(type: .roundedRect)
        let showButton = GrayButton(type: .roundedRect)
        
        [loadButton, showButton].forEach {
            buttonStack.addArrangedSubview($0)
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        }
        
        loadButton.setTitle("load ad", for: .normal)
        loadButton.addTarget(self, action: #selector(tapLoadButton), for: .touchUpInside)
        showButton.setTitle("show", for: .normal)
        showButton.addTarget(self, action: #selector(tapShowButton), for: .touchUpInside)
        
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.spacing = 15
        buttonStack.backgroundColor = .white
    }
    
    func setVideoView() {
        [videoAdView].forEach {
            self.view.addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.videoAdView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.videoAdView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            self.videoAdView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.videoAdView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.videoAdView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func tapLoadButton() {
        setVideoView()
        videoAdView.loadAd()
    }
    
    @objc func tapShowButton() {
        videoAdView.showAd()
    }
}

@available(iOS 13.0, *)
struct VideoAdViewControllerWrapper: UIViewControllerRepresentable {
    let adInfo: AMVideoAdInfo
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: VideoAdViewController(adInfo: adInfo))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
