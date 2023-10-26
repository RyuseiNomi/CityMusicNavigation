//
//  MusicModels.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/24.
//

import UIKit
import StoreKit
import MusicKit
import MediaPlayer

class MusicManager: NSObject, ObservableObject {
    
    var isSerching: Bool = false
    let musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    
    override init() {
        super.init()
        SKCloudServiceController.requestAuthorization { ( status: SKCloudServiceAuthorizationStatus) in
            switch status {
            case .authorized: self.startMusic()
            default: break
            }
        }
    }
    
    func startMusic() {
        Task {
            let selectedMusics = MPMediaQuery.albums()
            musicPlayer.setQueue(with: selectedMusics)
            musicPlayer.play()
        }
    }
}
