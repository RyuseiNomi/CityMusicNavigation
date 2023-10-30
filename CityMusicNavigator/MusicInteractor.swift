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
        musicPlayer.repeatMode = .one
    }
    
    public func fetchAlbums(appState: AppState) {
        let query = MPMediaQuery.albums()
        query.groupingType = MPMediaGrouping.album
        if let collections = query.collections {
            appState.musicObject.albums = collections
        }
    }
    
    public func fetchPlayLists(appState: AppState) {
        let query = MPMediaQuery.playlists()
        query.groupingType = MPMediaGrouping.playlist
        if let playLists = query.collections {
            appState.musicObject.playLists = playLists as! [MPMediaPlaylist]
        }
    }
}
