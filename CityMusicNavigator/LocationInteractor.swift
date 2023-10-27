//
//  MapModels.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/24.
//

import MapKit
import CoreLocation

class LocationInteractor: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // FIXME: Publishing changes from within view updates is not allowed, this will cause undefined behavior.
    public var appState: AppState = AppState()
    private let manager = CLLocationManager()
    @Published var region = MKCoordinateRegion()
    
    override init() {
        super.init()
    }
    
    func setUp(appState: AppState) {
        self.appState = appState
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 3.0
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            self.appState.locationObject.latitude = $0.coordinate.latitude
            self.appState.locationObject.longitude = $0.coordinate.longitude
            let center = CLLocationCoordinate2D(
                latitude: self.appState.locationObject.latitude,
                longitude: self.appState.locationObject.longitude
            )
            region = MKCoordinateRegion(
                center: center,
                latitudinalMeters: 1000.0,
                longitudinalMeters: 1000.0
            )
        }
        
        // ジオコーディングを行い state に現在位置情報を格納する
        let geoLocationInteractor = GeoLocationInteractor(appState: self.appState)
        geoLocationInteractor.updateAddress()
    }
}
