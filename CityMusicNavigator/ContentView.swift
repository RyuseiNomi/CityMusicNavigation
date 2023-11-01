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
    
    @ObservedObject var manager = LocationInteractor()
    @State var trackingMode = MapUserTrackingMode.follow
    @EnvironmentObject public var appState: AppState
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // マップ全体と住所表示
                ZStack(alignment: .topTrailing) {
                    Map(
                        coordinateRegion: $manager.region,
                        showsUserLocation: true,
                        userTrackingMode: $trackingMode
                    )
                    .onAppear() {
                        manager.setUp(appState: appState)
                    }
                    .frame(maxHeight: geometry.size.height / 2 )
                    
                    HStack {
                        Text(self.appState.locationObject.prefecture)
                            .foregroundColor(Color("textColor"))
                        Text(self.appState.locationObject.city)
                            .foregroundColor(Color("textColor"))
                        Text(self.appState.locationObject.town)
                            .foregroundColor(Color("textColor"))
                    }
                    .font(.subheadline)
                    .frame(maxWidth: geometry.size.width / 2, maxHeight: 45)
                    .background(Color("buttonColor"))
                    .onChange(of: self.appState.locationObject.town) {
                        self.appState.musicObject.musicInteractor.musicPlayer.skipToNextItem()
                        self.appState.musicObject.currentSong = self.appState.musicObject.musicInteractor.musicPlayer.nowPlayingItem
                    }
                }
                .padding(.top, 10)
                .frame(maxHeight: geometry.size.height / 3)
                
                SampleMusicOperationView()
                    .background(Color("backgroundColor"))
                    .onAppear() {
                        self.appState.musicObject.musicInteractor.setSamplePlayList(appState: self.appState)
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
