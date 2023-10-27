//
//  MusicModels.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/24.
//

import SwiftUI
import StoreKit
import MediaPlayer

class MusicInteractor: NSObject, ObservableObject {
    
    @Published var musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    
    override init() {
        super.init()
        SKCloudServiceController.requestAuthorization { ( status: SKCloudServiceAuthorizationStatus) in
            switch status {
            case .denied: Text("音楽へのアクセスが拒否されています")
            case .restricted: Text("音楽へのアクセスが制限されています")
            default: break
            }
        }
    }
}
