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
    @ObservedObject var manager = LocationManager()
    @State var trackingMode = MapUserTrackingMode.follow
    @EnvironmentObject public var appState: AppState
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $manager.region,
                showsUserLocation: true,
                userTrackingMode: $trackingMode
            ).edgesIgnoringSafeArea(.bottom)
            .onAppear() {
                manager.setUp(appState: appState)
            }
            HStack {
                Text("現在地 : ")
                Text(self.appState.locationObject.prefecture)
                Text(self.appState.locationObject.city)
                Text(self.appState.locationObject.town)
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
}

#Preview {
    ContentView()
}
