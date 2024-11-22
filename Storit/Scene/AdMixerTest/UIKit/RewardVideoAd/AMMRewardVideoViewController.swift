//
//  AMMRewardVideoViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixerMediation

class AMMRewardVideoViewController: UIViewController {
   
    let adUnitId: Int
    var aMMRewardVideo: AMMRewardVideo!
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
        self.title = "Mediation - RewardVideo"
        
        
        aMMRewardVideo = AMMRewardVideo()
        aMMRewardVideo.adUnitID = self.adUnitId
        aMMRewardVideo.viewController = self
        aMMRewardVideo.delegate = self
        
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
        aMMRewardVideo.load()
    }
}

extension AMMRewardVideoViewController: AMMRewardVideoDelegate {
    func onRewardVideoComplete() {
        //
    }
    
    func onSuccessRewardVideo() {
        //
    }
    
    func onTapRewardVideo() {
        //
    }
    
    func onFailRewardVideo() {
        //
    }
    
    func onCloseRewardVideo() {
        //
    }
}

@available(iOS 13.0, *)
struct AMMRewardVideoViewControllerWrapper: UIViewControllerRepresentable {
    let adUnitId: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: AMMRewardVideoViewController(adUnitId: adUnitId))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
