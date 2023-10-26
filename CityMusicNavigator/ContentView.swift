//
//  ContentView.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/24.
//

import SwiftUI
import MapKit
import MediaPlayer

struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var musicManager = MusicManager()
    @State var trackingMode = MapUserTrackingMode.follow
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                userTrackingMode: $trackingMode
            ).edgesIgnoringSafeArea(.bottom)
            Grid {
                GridRow {
                    Button("▶️") {
                        Task {
                            let selectedMusics = MPMediaQuery.albums()
                            $musicManager.musicPlayer.wrappedValue.setQueue(with: selectedMusics)
                            $musicManager.musicPlayer.wrappedValue.play()
                        }
                    }
                    Button("⏸️") {
                        Task {
                            $musicManager.musicPlayer.wrappedValue.stop()
                        }
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
