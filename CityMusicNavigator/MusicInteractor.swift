//
//  MusicModels.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/24.
//

import SwiftUI
import StoreKit
import MediaPlayer
import AVFoundation

class MusicInteractor: NSObject, ObservableObject {
    
    @Published var musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    var player: AVAudioPlayer?
    
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
    
    public func setSamplePlayList(appState: AppState) {
        let fileManager = FileManager.default
        let path = URL(string: Bundle.main.bundlePath)
        
        do {
            let contentUrls = try fileManager.contentsOfDirectory(at: path!, includingPropertiesForKeys: nil)
            for contentUrl in contentUrls {
                if contentUrl.lastPathComponent.contains(".mp3") {
                    appState.musicObject.samplePlayList.append(contentUrl)
                }
            }
            player = try? AVAudioPlayer(contentsOf: appState.musicObject.samplePlayList.first!)
            appState.musicObject.currentSampleSong = player
            appState.musicObject.currentSamplePlayNumber = 1
        } catch {
            print("error")
        }
    }
}
