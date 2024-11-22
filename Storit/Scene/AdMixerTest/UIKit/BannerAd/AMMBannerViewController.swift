//
//  AMMBannerViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixerMediation

class AMMBannerViewController: UIViewController {
    
    let adUnitId: Int
    var ammbanner: AMMBannerView!
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
        self.title = "Mediation - Banner"
        
        ammbanner = AMMBannerView(width: view.frame.size.width)
        addBannerViewToView(ammbanner)
        ammbanner.adUnitID = adUnitId
        ammbanner.delegate = self
        
        
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
        ammbanner.load()
    }
    
    func addBannerViewToView(_ bannerView: UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])
     }
}

extension AMMBannerViewController: AMMBannerViewDelegate {
    func onSuccessBanner() {
        print("AMMBannerViewController - onSuccessBanner")
    }
    
    func onFailBanner() {
        print("AMMBannerViewController - onFailBanner")
    }
}


@available(iOS 13.0, *)
struct AMMBannerViewControllerWrapper: UIViewControllerRepresentable {
    let adUnit: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: AMMBannerViewController(adUnitId: adUnit))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
