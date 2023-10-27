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
    
    @ObservedObject var musicInteractor = MusicInteractor()
    @ObservedObject var manager = LocationInteractor()
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
            .onChange(of: self.appState.locationObject.town) {
                $musicInteractor.musicPlayer.wrappedValue.skipToNextItem()
            }
            Button("アルバムを選択") {
                Task {
                    musicInteractor.fetchAlbums(appState: self.appState)
                    self.appState.sheetObject.isShowAlbumSheet.toggle()
                }
            }
            .sheet(isPresented: self.$appState.sheetObject.isShowAlbumSheet) {
                AlbumPickView()
                    .presentationContentInteraction(.scrolls)
            }
            Grid {
                GridRow {
                    Button("前の曲") {
                        Task {
                            $musicInteractor.musicPlayer.wrappedValue.skipToPreviousItem()
                        }
                    }
                    Button("再生") {
                        Task {
                            let album = self.appState.musicObject.album
                            $musicInteractor.musicPlayer.wrappedValue.setQueue(with: album)
                            $musicInteractor.musicPlayer.wrappedValue.play()
                        }
                    }
                    Button("一時停止") {
                        Task {
                            $musicInteractor.musicPlayer.wrappedValue.pause()
                        }
                    }
                    Button("停止") {
                        Task {
                            $musicInteractor.musicPlayer.wrappedValue.stop()
                        }
                    }
                    Button("次の曲") {
                        Task {
                            $musicInteractor.musicPlayer.wrappedValue.skipToNextItem()
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
