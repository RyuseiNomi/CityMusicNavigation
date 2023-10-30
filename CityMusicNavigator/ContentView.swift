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
    @State var pauseTime: Double = 0.0
    @State var isPlayingMusic: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // マップ全体と住所表示
                ZStack(alignment: .topTrailing) {
                    Map(
                        coordinateRegion: $manager.region,
                        showsUserLocation: true,
                        userTrackingMode: $trackingMode
                    ).edgesIgnoringSafeArea(.bottom)
                        .onAppear() {
                            manager.setUp(appState: appState)
                        }
                        .frame(maxHeight: geometry.size.height / 2 )
                    
                    HStack {
                        Text(self.appState.locationObject.prefecture)
                            .foregroundColor(Color.white)
                        Text(self.appState.locationObject.city)
                            .foregroundColor(Color.white)
                        Text(self.appState.locationObject.town)
                            .foregroundColor(Color.white)
                    }
                    .font(.subheadline)
                    .frame(maxWidth: geometry.size.width / 2, maxHeight: 45)
                    .background(Color.gray)
                    .border(Color.black, width: 5)
                    .onChange(of: self.appState.locationObject.town) {
                        $musicInteractor.musicPlayer.wrappedValue.skipToNextItem()
                    }
                }
                
                // 再生中の曲の情報
                VStack {
                    if (self.appState.musicObject.currentSong != nil) {
                        if let artwork = self.appState.musicObject.currentSong?.artwork {
                            Image(uiImage: artwork.image(at: CGSize(width: 30, height: 30))!)
                        } else {
                            Image("jacket")
                                .resizable()
                                .frame(maxWidth: 150, maxHeight: 150)
                                .padding(.bottom, 0)
                            
                        }
                        Text((self.appState.musicObject.currentSong?.title)!)
                    } else {
                        Image("jacket")
                            .resizable()
                            .frame(maxWidth: 150, maxHeight: 150)
                            .padding(.bottom, 0)
                        Text("---")
                            .padding(.top, 10)
                            .padding(.bottom, 0)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2)
                
                // 音楽操作パネル
                Grid {
                    GridRow {
                        Button(action: {
                            $musicInteractor.musicPlayer.wrappedValue.skipToPreviousItem()
                            self.appState.musicObject.currentSong = musicInteractor.musicPlayer.nowPlayingItem
                        }, label: {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .frame(maxWidth: 30, maxHeight: 30)
                        })
                        Spacer()
                        if self.isPlayingMusic {
                            Button(action: {
                                $musicInteractor.musicPlayer.wrappedValue.pause()
                                isPlayingMusic.toggle()
                                self.pauseTime = $musicInteractor.musicPlayer.wrappedValue.currentPlaybackTime
                            }, label: {
                                Image(systemName: "pause.circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 70, maxHeight: 70)
                            })
                        } else {
                            Button(action: {
                                if let album = self.appState.musicObject.album {
                                    if $musicInteractor.musicPlayer.wrappedValue.nowPlayingItem == nil {
                                        $musicInteractor.musicPlayer.wrappedValue.setQueue(with: album)
                                    } else {
                                        $musicInteractor.musicPlayer.wrappedValue.currentPlaybackTime = pauseTime
                                    }
                                    $musicInteractor.musicPlayer.wrappedValue.play()
                                    isPlayingMusic.toggle()
                                    return
                                }
                                if let playList = self.appState.musicObject.playList {
                                    if $musicInteractor.musicPlayer.wrappedValue.nowPlayingItem == nil {
                                        $musicInteractor.musicPlayer.wrappedValue.setQueue(with: playList)
                                    } else {
                                        $musicInteractor.musicPlayer.wrappedValue.currentPlaybackTime = pauseTime
                                    }
                                    $musicInteractor.musicPlayer.wrappedValue.play()
                                    isPlayingMusic.toggle()
                                }
                            }, label: {
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 70, maxHeight: 70)
                            })
                        }
                        Spacer()
                        Button(action: {
                            $musicInteractor.musicPlayer.wrappedValue.skipToNextItem()
                            self.appState.musicObject.currentSong = musicInteractor.musicPlayer.nowPlayingItem
                            
                        }, label: {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .frame(maxWidth: 30, maxHeight: 30)
                        })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 5)
                .padding(.horizontal, 50)
                
                // アルバム or プレイリスト選択
                HStack {
                    Button(action: {
                        musicInteractor.fetchAlbums(appState: self.appState)
                        self.appState.sheetObject.isShowAlbumSheet.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "rectangle.stack.fill")
                                .resizable()
                                .frame(maxWidth: 40, maxHeight: 40)
                            VStack {
                                Text("アルバム")
                                    .bold()
                                    .font(.title2)
                                Text("から選択")
                            }
                        }
                    })
                    .sheet(isPresented: self.$appState.sheetObject.isShowAlbumSheet) {
                        AlbumPickView()
                            .presentationContentInteraction(.scrolls)
                    }
                    Spacer()
                    Button(action: {
                        musicInteractor.fetchPlayLists(appState: self.appState)
                        self.appState.sheetObject.isShowPlayListSheet.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "music.note.list")
                                .resizable()
                                .frame(maxWidth: 40, maxHeight: 40)
                            VStack {
                                Text("プレイリスト")
                                    .bold()
                                    .font(.title3)
                                Text("から選択")
                            }
                        }
                    })
                    .sheet(isPresented: self.$appState.sheetObject.isShowPlayListSheet) {
                        PlayListPickView()
                            .presentationContentInteraction(.scrolls)
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 6)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
