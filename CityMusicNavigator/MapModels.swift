//
//  MapModels.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/24.
//

import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    public var appState: AppState = AppState()
    private let manager = CLLocationManager()
    @Published var region = MKCoordinateRegion()
    
    override init() {
        super.init()
    }
    
    func setUp(appState: AppState) {
        self.appState = appState
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 3.0
        print("a")
        manager.startUpdatingLocation()
        print("d")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("b")
        locations.last.map {
            self.appState.locationObject.latitude = $0.coordinate.latitude
            self.appState.locationObject.longitude = $0.coordinate.longitude
            print("c")
            print(self.appState.locationObject.latitude)
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
