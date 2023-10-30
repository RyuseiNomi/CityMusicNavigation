//
//  AppState.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/26.
//

import SwiftUI
import MapKit
import MediaPlayer

class AppState: ObservableObject {
    
    struct LocationObject {
        var latitude: CLLocationDegrees = 0.0
        var longitude: CLLocationDegrees = 0.0
        var prefecture: String = ""
        var city: String = ""
        var town: String = ""
    }
    
    struct MusicObject {
        var musicPlayer: MPMusicPlayerApplicationController = MPMusicPlayerApplicationController.applicationQueuePlayer
        // NOTE: 曲を再生する際にアルバムかプレイリストどちらが選択されているか確認するため
        var album: MPMediaItemCollection? = nil
        var albums: [MPMediaItemCollection] = [.init(items: [MPMediaItem()])]
        var playList: MPMediaPlaylist? = nil
        var playLists: [MPMediaPlaylist] = [.init(items: [MPMediaItem()])]
        var currentSong: MPMediaItem? = nil
        var pauseTime: Double = 0.0
        var isPlayingMusic: Bool = false
        var musicInteractor: MusicInteractor = MusicInteractor()
    }
    
    struct SheetObject {
        var isShowAlbumSheet: Bool = false
        var isShowPlayListSheet: Bool = false
    }
    
    @Published public var locationObject = LocationObject()
    @Published public var musicObject = MusicObject()
    @Published public var sheetObject = SheetObject()
}
