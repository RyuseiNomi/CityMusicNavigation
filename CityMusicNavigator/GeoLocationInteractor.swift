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
                    self.updateAddressState(place: place)
                }
            }
        }
    }
    
    private func updateAddressState(place: CLPlacemark) {
        if let subLocality = place.subLocality {
            // 住所が変更されていない場合は処理を抜ける
            if ( self.appState.locationObject.town == subLocality ) {
                return
            }
            
            // 住所が初期値の場合は state とインスタンス変数を更新する
            if ( self.appState.locationObject.prefecture == "" ) {
                // state の更新
                self.appState.locationObject.prefecture = place.administrativeArea!
                self.appState.locationObject.city = place.locality!
                self.appState.locationObject.town = place.subLocality!
                return
            }
        
            // 町が更新されている場合には次の音楽をかける
            if ( subLocality != self.appState.locationObject.town ) {
                // TODO: 次の音楽に skip する
                // 新しい街の情報を更新する
                self.appState.locationObject.prefecture = place.administrativeArea!
                self.appState.locationObject.city = place.locality!
                self.appState.locationObject.town = subLocality
            }
        }
    }
}
