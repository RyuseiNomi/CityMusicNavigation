//
//  MapModels.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/24.
//

import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    public var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
        self.appState.mapObject.manager.delegate = self
        self.appState.mapObject.manager.requestWhenInUseAuthorization()
        self.appState.mapObject.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.appState.mapObject.manager.distanceFilter = 3.0
        self.appState.mapObject.manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            self.appState.locationObject.latitude = $0.coordinate.latitude
            self.appState.locationObject.longitude = $0.coordinate.longitude
            let center = CLLocationCoordinate2D(
                latitude: self.appState.locationObject.latitude,
                longitude: self.appState.locationObject.longitude
            )
            self.appState.mapObject.region = MKCoordinateRegion(
                center: center,
                latitudinalMeters: 1000.0,
                longitudinalMeters: 1000.0
            )
        }
    }
}
