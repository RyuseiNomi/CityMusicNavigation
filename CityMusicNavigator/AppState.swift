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
        // アルバム
        // NOTE: 曲を再生する際にアルバムかプレイリストどちらが選択されているか確認するため nil にしている
        var album: MPMediaItemCollection? = nil
        var albums: [MPMediaItemCollection] = [.init(items: [MPMediaItem()])]
        
        // プレイリスト
        var playList: MPMediaPlaylist? = nil
        var playLists: [MPMediaPlaylist] = [.init(items: [MPMediaItem()])]
        
        // 初期のサンプル音源
        var samplePlayList: [URL] = []
        var currentSamplePlayNumber: Int = 0
        var currentSampleSong: AVAudioPlayer? = nil
        
        // 現在選択されている曲の情報
        var sampleCurrentSong: MPMediaItem? = nil
        var currentSong: MPMediaItem? = nil
        
        // 一時停止に関わる情報
        var pauseTime: Double = 0.0
        var sampleSongPauseTime: TimeInterval = 0.0
        var isPlayingMusic: Bool = false
        
        // 音楽に関する操作をするクラス
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
