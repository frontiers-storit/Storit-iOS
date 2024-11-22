//
//  AdUnitSectionView.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import SwiftUI
import AdMixer

struct AdUnitSectionView: View {
    
    let adType: AdType
    let serverType: ServerType
    @Binding var isMediationEnabled: Bool
    @Binding var adUnitId: String
    @Binding var bannerType: AMFullBannerType
    let onRequest: () -> Void

    var body: some View {
        Section {
            Toggle("미디에이션", isOn: $isMediationEnabled)
                .disabled(!adType.isMediationEnabled)

            HStack {
                Text("Ad Unit")
                TextField("adUnitId", text: $adUnitId)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
            switch serverType {
            case .test:
                if let adUnits = adType.testAdUnits {
                    HStack {
                        Picker("Test Ad Unit List", selection: $adUnitId) {
                            ForEach(adUnits.keys.sorted(), id: \.self) { key in
                                Text("\(key) (\(adUnits[key] ?? ""))")
                                    .tag(String(key))
                            }
                        }
                    }
                }
            case .production:
                if let adUnits = adType.prodAdUnits {
                    HStack {
                        Picker("Test Ad Unit", selection: $adUnitId) {
                            ForEach(adUnits.keys.sorted(), id: \.self) { key in
                                Text("\(key) (\(adUnits[key] ?? ""))")
                                    .tag(String(key))
                            }
                        }
                    }
                }
            }
            
            if adType == .fullBanner {
                Picker("전면 배너 타입", selection: $bannerType) {
                    ForEach([AMFullBannerType.basic, AMFullBannerType.popup], id: \.self) { key in
                        Text("\(key)")
                    }
                }
            }

            HStack {
                Spacer()
                Button("광고 보기", action: onRequest)
                Spacer()
            }
        } header: {
            Text(adType.title)
        }
    }
}
//
//#Preview {
//    AdUnitSectionView(title: "test",
//                      isMediationEnabled: .constant(false),
//                      adUnitId: .constant(String(24)),
//                      adUnits: [:],
//                      isFocused: true,
//                      onRequest: {})
//}
