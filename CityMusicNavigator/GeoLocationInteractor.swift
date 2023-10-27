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
    
    public func updateAddress() {
        let address = CLGeocoder.init()
        let location = CLLocation(latitude: self.appState.locationObject.latitude, longitude: self.appState.locationObject.longitude)
        address.reverseGeocodeLocation(location) { (places, error) in
            if error == nil {
                if let place = places?.first {
                    self.appState.locationObject.prefecture = place.administrativeArea!
                    self.appState.locationObject.city = place.locality!
                    self.appState.locationObject.town = place.subLocality!
                }
            }
        }
    }
}
