//
//  AdMixerSettingViewModel.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import SwiftUI
import AdMixer
import AdMixerMediation

class AdMixerSettingViewModel: ObservableObject {
    
    @Published var mediaId: String = String(ServerType.production.mediaKey)
    @Published var serverType: ServerType = .production {
        didSet {
            setChangedData()
        }
    }
    @Published var isTestMode: Bool = true
    
    // 광고 별 미디에이션 사용 유무
    @Published var isBannerMedi: Bool = AdType.banner.isMediationEnabled
    @Published var isFullBannerMedi: Bool = AdType.fullBanner.isMediationEnabled
    @Published var isVideoMedi: Bool = AdType.instreamVideo.isMediationEnabled
    @Published var isFullVideoMedi: Bool = AdType.fullVideo.isMediationEnabled
    @Published var isRewardVideoMedi: Bool = AdType.rewardVideo.isMediationEnabled
    @Published var isNativeMedi: Bool = AdType.native.isMediationEnabled
    
    // 광고 별 애드유닛
    @Published var bannerAdUnitId: String = ""
    @Published var fullBannerAdUnitId: String = ""
    @Published var videoAdUnitId: String = ""
    @Published var fullVideoAdUnitId: String = ""
    @Published var rewardVideoAdUnitId: String = ""
    @Published var nativeAdUnitId: String = ""
    
    @Published var fullBannerType: AMFullBannerType = .basic
    
    let serverTypeOptions = ["개발", "운영"]
    
    init() {
        AMMediation.shared.setDebugEnabled(isEnabled: true)
        AMMediation.shared.setDebugEnabled(isEnabled: true)
        AdMixerSDK.shared.debug(isEnabled: true)
        AdMixerSDK.shared.setTimeoutIntervalForRequest(time: TimeInterval(60), code: 2188)
        AdMixerSDK.shared.setTestMode(isTestMode: false, code: 2188)
    }
    
    func setChangedData() {
//        mediaId = String(serverType.mediaKey)
        bannerAdUnitId = ""
        fullBannerAdUnitId = ""
        videoAdUnitId = ""
        fullVideoAdUnitId = ""
        rewardVideoAdUnitId = ""
        nativeAdUnitId = ""
    }
    
    func destinationView(for adType: AdType) -> some View {
                
        if serverType == .production {
            AMMediationSDK.shared.hostUrl = "https://amssp.admixer.co.kr/api/v1/mda"
            AdMixerSDK.shared.setTestMode(isTestMode: false, code: 2188)
        } else {
            AMMediationSDK.shared.hostUrl = "http://222.122.225.84:25848/api/v1/mda"
            AdMixerSDK.shared.setTestMode(isTestMode: true, code: 2188)
        }
        
        switch adType {
        case .banner:
            if !isBannerMedi, let adUnitId = Int(bannerAdUnitId) {
                let adInfo = AMBannerAdInfo(mediaKey: mediaId, adUnitId: adUnitId)
                return AnyView(BannerAdViewControllerWrapper(adInfo: adInfo))
            } else if isBannerMedi, let adUnitId = Int(bannerAdUnitId) {
                AMMediation.shared.initialize(mediaKey: Int(mediaId)!, adunitID: [adUnitId])
                return AnyView(AMMBannerViewControllerWrapper(adUnit: adUnitId))
            }
        case .fullBanner:
            if !isFullBannerMedi, let adUnitId = Int(fullBannerAdUnitId) {
                let adInfo = AMFullBannerAdInfo(mediaKey: mediaId, adUnitId: adUnitId, type: fullBannerType)
                return AnyView(FullBannerAdViewControllerWrapper(adInfo: adInfo))
            } else if isFullBannerMedi, let adUnitId = Int(fullBannerAdUnitId) {
                AMMediation.shared.initialize(mediaKey: Int(mediaId)!, adunitID: [adUnitId])
                return AnyView(AMMFullBannerViewControllerWrapper(adUnit: adUnitId, viewType: fullBannerType))
            }
        case .instreamVideo:
            if !isVideoMedi, let adUnitId = Int(videoAdUnitId) {
                let adInfo = AMVideoAdInfo(mediaKey: mediaId, adUnitId: adUnitId)
                return AnyView(VideoAdViewControllerWrapper(adInfo: adInfo))
            } else if isVideoMedi, let adUnitId = Int(videoAdUnitId) {
                AMMediation.shared.initialize(mediaKey: Int(mediaId)!, adunitID: [adUnitId])
                return AnyView(AMMVideoViewControllerWrapper(adUnit: adUnitId))
            }
        case .fullVideo:
            if !isFullVideoMedi, let adUnitId = Int(fullVideoAdUnitId) {
                let adInfo = AMVideoAdInfo(mediaKey: mediaId, adUnitId: adUnitId)
                return AnyView(FullVideoAdViewControllerWrapper(adInfo: adInfo))
            } else if isVideoMedi, let adUnitId = Int(fullVideoAdUnitId) {
                AMMediation.shared.initialize(mediaKey: Int(mediaId)!, adunitID: [adUnitId])
                return AnyView(AMMFullVideoViewControllerWrapper(adUnit: adUnitId))
            }
        case .rewardVideo:
            if !isRewardVideoMedi, let adUnitId = Int(rewardVideoAdUnitId) {
                let adInfo = AMVideoAdInfo(mediaKey: mediaId, adUnitId: adUnitId)
                return AnyView(RewardVideoViewControllerWrapper(adInfo: adInfo))
            } else if isRewardVideoMedi, let adUnitId = Int(rewardVideoAdUnitId) {
                AMMediation.shared.initialize(mediaKey: Int(mediaId)!, adunitID: [adUnitId])
                return AnyView(AMMRewardVideoViewControllerWrapper(adUnitId: adUnitId))
            }
        case .native:
            if !isNativeMedi, let adUnitId = Int(nativeAdUnitId) {
                let adInfo = AMNativeAdInfo(mediaKey: mediaId, adUnitId: adUnitId)
                return AnyView(NativeAdViewControllerWrapper(adInfo: adInfo))
            } else if isNativeMedi, let adUnitId = Int(nativeAdUnitId) {
                AMMediation.shared.initialize(mediaKey: Int(mediaId)!, adunitID: [adUnitId])
                return AnyView(AMMNativeAdViewControllerWrapper(adUnitID: adUnitId))
            }
        }
        return AnyView(EmptyView())
    }
}
