//
//  AdMixerSettingView.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import SwiftUI
import AdMixer

struct AdMixerSettingView: View {
    
    @ObservedObject var viewModel: AdMixerSettingViewModel
    @State var path: [AdType] = []
    @State private var isNavigationActive: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                serverSection
                mediaSection
                bannerSection
                fullBannerSection
                videoSection
                fullVideoSection
                rewardVideoSection
                nativeSection
            }
            .navigationBarTitle(
                "AdMixerMediationTest",
                displayMode: .large
            )
            .onAppear(perform: {
                UIApplication.shared.hideKeyboard()
            })
            .background(
                NavigationLink(
                    destination: viewModel.destinationView(for: path.last ?? .banner),
                    isActive: $isNavigationActive
                ) {
                        EmptyView()
                    }
                )
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private var serverSection: some View {
        Section {
            Picker(
                "서버",
                selection: $viewModel.serverType
            ) {
                ForEach(ServerType.allCases, id: \.self) {
                    Text($0.title)
                }
            }
            .pickerStyle(.segmented)
            
        } header: {
            Text("서버")
        }
    }
    
    private var mediaSection: some View {
        Section {
            HStack {
                Text("mediaId")
                TextField("mediaId", text: $viewModel.mediaId)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
        } header: {
            Text("미디어 정보")
        }
    }
    
    private var bannerSection: some View {
        AdUnitSectionView(
            adType: .banner,
            serverType: viewModel.serverType,
            isMediationEnabled: $viewModel.isBannerMedi,
            adUnitId: $viewModel.bannerAdUnitId,
            bannerType: $viewModel.fullBannerType,
            onRequest: {
                navigate(to: .banner)
            }
        )
    }
    
    private var fullBannerSection: some View {
        AdUnitSectionView(
            adType: .fullBanner,
            serverType: viewModel.serverType,
            isMediationEnabled: $viewModel.isFullBannerMedi,
            adUnitId: $viewModel.fullBannerAdUnitId,
            bannerType: $viewModel.fullBannerType,
            onRequest: {
                navigate(to: .fullBanner)
            }
        )
    }
    
    private var videoSection: some View {
        AdUnitSectionView(
            adType: .instreamVideo,
            serverType: viewModel.serverType,
            isMediationEnabled: $viewModel.isVideoMedi,
            adUnitId: $viewModel.videoAdUnitId,
            bannerType: $viewModel.fullBannerType,
            onRequest: {
                navigate(to: .instreamVideo)
            }
        )
    }
    
    private var fullVideoSection: some View {
        AdUnitSectionView(
            adType: .fullVideo,
            serverType: viewModel.serverType,
            isMediationEnabled: $viewModel.isFullVideoMedi,
            adUnitId: $viewModel.fullVideoAdUnitId,
            bannerType: $viewModel.fullBannerType,
            onRequest: {
                navigate(to: .fullVideo)
            }
        )
    }
    
    private var rewardVideoSection: some View {
        AdUnitSectionView(
            adType: .rewardVideo,
            serverType: viewModel.serverType,
            isMediationEnabled: $viewModel.isRewardVideoMedi,
            adUnitId: $viewModel.rewardVideoAdUnitId,
            bannerType: $viewModel.fullBannerType,
            onRequest: {
                navigate(to: .rewardVideo)
            }
        )
    }
    
    private var nativeSection: some View {
        AdUnitSectionView(
            adType: .native,
            serverType: viewModel.serverType,
            isMediationEnabled: $viewModel.isNativeMedi,
            adUnitId: $viewModel.nativeAdUnitId,
            bannerType: $viewModel.fullBannerType,
            onRequest: {
                navigate(to: .native)
            }
        )
    }
    
    private func navigate(to viewType: AdType) {
        print("\(viewType.title) 광고로 이동")
        path.append(viewType)
        isNavigationActive = true
    }
}
