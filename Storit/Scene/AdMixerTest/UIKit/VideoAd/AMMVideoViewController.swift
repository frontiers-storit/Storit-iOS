//
//  AMMVideoViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixerMediation

class AMMVideoViewController: UIViewController {
    
    let adUnitId: Int
    var ammVideoView: AMMVideoView!
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
        self.title = "Mediation - Video"
        
        ammVideoView = AMMVideoView()
        addBannerViewToView(ammVideoView)
        ammVideoView.adUnitID = adUnitId
        ammVideoView.delegate = self
        
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
        ammVideoView.load()
    }
    
    func addBannerViewToView(_ bannerView: UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            bannerView.heightAnchor.constraint(equalToConstant: 400)
        ])
     }
}

extension AMMVideoViewController: AMMVideoViewDelegate {
    func onSuccessVideo() {
        print("AMMVideoViewController - onSuccessVideo")
    }
    
    func onFailVideo() {
        print("AMMVideoViewController - onFailVideo")
    }
    
    func onSkipVideo() {
        print("AMMVideoViewController - onSkipVideo")
    }
    
    func onTapVideoViewMore() {
        print("AAMMVideoViewController - onTapAdViewMore")
    }
}


@available(iOS 13.0, *)
struct AMMVideoViewControllerWrapper: UIViewControllerRepresentable {
    let adUnit: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: AMMVideoViewController(adUnitId: adUnit))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
