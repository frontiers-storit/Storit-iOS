//
//  FullVideoAdViewController.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit
import SwiftUI
import AdMixer

class FullVideoAdViewController: UIViewController {
    
    let adInfo: AMVideoAdInfo
    lazy var fullVideo = AMVideoAdViewController(adInfo: self.adInfo, rootViewController: self)
    let buttonStack = UIStackView()
    
    init(adInfo: AMVideoAdInfo) {
        self.adInfo = adInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        self.title = "AdMixer - FullVideo"
    }
}

extension FullVideoAdViewController {
    func setLayout() {
        self.view.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.backgroundColor = .yellow
        
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
   
    @objc func tapLoadButton() {
        fullVideo.loadAd()
    }
    
    @objc func tapShowButton() {
        fullVideo.showAd(animated: true)
    }
}

@available(iOS 13.0, *)
struct FullVideoAdViewControllerWrapper: UIViewControllerRepresentable {
    let adInfo: AMVideoAdInfo
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: FullVideoAdViewController(adInfo: adInfo))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
