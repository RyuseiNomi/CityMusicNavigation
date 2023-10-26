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
    
    @ObservedObject var musicManager = MusicManager()
    @State var trackingMode = MapUserTrackingMode.follow
    @State private var region = MKCoordinateRegion()
    @EnvironmentObject public var appState: AppState
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                userTrackingMode: $trackingMode
            ).edgesIgnoringSafeArea(.bottom)
            Button(action: {
                let geoLocationInteractor = GeoLocationInteractor(appState: self.appState)
                geoLocationInteractor.getLocation()
            }) {
               Text("位置情報の取得を開始")
            }
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
    
    private func getRegion() {
        self.region = self.appState.mapObject.region
    }
}

#Preview {
    ContentView()
}
