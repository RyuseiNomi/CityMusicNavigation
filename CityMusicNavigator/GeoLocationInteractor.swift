//
//  GeoLocationInteractor.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/26.
//

import Foundation
import MapKit
import CoreLocation

class GeoLocationInteractor {
    
    public var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    public func getLocation() {
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: self.appState.locationObject.latitude, longitude: self.appState.locationObject.longitude)) { (places, error) in
            if let place = places?.first {
                print(self.appState.locationObject.latitude)
            }
        }
    }
}
