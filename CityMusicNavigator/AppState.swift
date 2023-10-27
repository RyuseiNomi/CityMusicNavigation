//
//  AppState.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/26.
//

import SwiftUI
import MapKit

class AppState: ObservableObject {
    
    struct LocationObject {
        var latitude: CLLocationDegrees = 0.0
        var longitude: CLLocationDegrees = 0.0
        var prefecture: String = ""
        var city: String = ""
        var town: String = ""
    }
    
    struct MapObject {
        var region: MKCoordinateRegion = MKCoordinateRegion()
    }
    
    @Published public var locationObject = LocationObject()
    @Published public var mapObject = MapObject()
}
