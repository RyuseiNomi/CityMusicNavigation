//
//  ContentView.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var manager = LocationManager()
    @State var trackingMode = MapUserTrackingMode.follow
    
    var body: some View {
        Map(
            coordinateRegion: $manager.region,
            showsUserLocation: true,
            userTrackingMode: $trackingMode
        ).edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
}
