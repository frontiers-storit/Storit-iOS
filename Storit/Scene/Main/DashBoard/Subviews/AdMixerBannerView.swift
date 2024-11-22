//
//  AdMixerBannerView.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/20/24.
//

import Foundation
import SwiftUI
import AdMixerMediation
import AdMixer

struct AdMixerBannerView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        AMMediationSDK.shared.hostUrl = "https://amssp.admixer.co.kr/api/v1/mda"
        AdMixerSDK.shared.setTestMode(isTestMode: false, code: 2188)
        AMMediation.shared.initialize(mediaKey: 10068, adunitID: [100295])
        
        let banner = AMMBannerView(width: 320)
        banner.adUnitID = 100295
        banner.load()
        return banner
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        print("updateUIView")
        
        if let banner = uiView as? AMMBannerView {
            banner.load()
        }
    }
}
