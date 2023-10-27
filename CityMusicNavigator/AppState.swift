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
        var album: MPMediaItemCollection = .init(items: [MPMediaItem()])
        var albums: [MPMediaItemCollection] = [.init(items: [MPMediaItem()])]
    }
    
    struct SheetObject {
        var isShowAlbumSheet: Bool = false
    }
    
    @Published public var locationObject = LocationObject()
    @Published public var musicObject = MusicObject()
    @Published public var sheetObject = SheetObject()
}
