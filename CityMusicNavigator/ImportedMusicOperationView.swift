//
//  ImportedMusicOperationView.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/31.
//

import SwiftUI

struct ImportedMusicOperationView: View {
    
    @EnvironmentObject public var appState: AppState
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
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
                        Text("アルバムもしくはプレイリストから\n曲を選択してください")
                            .padding(.top, 10)
                            .padding(.bottom, 0)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2)
                
                // 音楽操作パネル
                Grid {
                    GridRow {
                        Button(action: {
                            self.appState.musicObject.musicInteractor.musicPlayer.skipToPreviousItem()
                            self.appState.musicObject.currentSong = self.appState.musicObject.musicInteractor.musicPlayer.nowPlayingItem
                        }, label: {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .foregroundColor(Color("buttonColor"))
                        })
                        Spacer()
                        if self.appState.musicObject.isPlayingMusic {
                            Button(action: {
                                self.appState.musicObject.musicInteractor.musicPlayer.pause()
                                self.appState.musicObject.isPlayingMusic.toggle()
                                self.appState.musicObject.pauseTime = self.appState.musicObject.musicInteractor.musicPlayer.currentPlaybackTime
                            }, label: {
                                Image(systemName: "pause.circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 70, maxHeight: 70)
                                    .foregroundColor(Color("buttonColor"))
                                
                            })
                        } else {
                            Button(action: {
                                if let album = self.appState.musicObject.album {
                                    if self.appState.musicObject.musicInteractor.musicPlayer.nowPlayingItem == nil {
                                        self.appState.musicObject.musicInteractor.musicPlayer.setQueue(with: album)
                                    } else {
                                        self.appState.musicObject.musicInteractor.musicPlayer.currentPlaybackTime = self.appState.musicObject.pauseTime
                                    }
                                    self.appState.musicObject.musicInteractor.musicPlayer.play()
                                    self.appState.musicObject.isPlayingMusic.toggle()
                                    return
                                }
                                if let playList = self.appState.musicObject.playList {
                                    if self.appState.musicObject.musicInteractor.musicPlayer.nowPlayingItem == nil {
                                        self.appState.musicObject.musicInteractor.musicPlayer.setQueue(with: playList)
                                    } else {
                                        self.appState.musicObject.musicInteractor.musicPlayer.currentPlaybackTime = self.appState.musicObject.pauseTime
                                    }
                                    self.appState.musicObject.musicInteractor.musicPlayer.play()
                                    self.appState.musicObject.isPlayingMusic.toggle()
                                }
                            }, label: {
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 70, maxHeight: 70)
                                    .foregroundColor(Color("buttonColor"))
                            })
                        }
                        Spacer()
                        Button(action: {
                            self.appState.musicObject.musicInteractor.musicPlayer.skipToNextItem()
                            self.appState.musicObject.currentSong = self.appState.musicObject.musicInteractor.musicPlayer.nowPlayingItem
                            
                        }, label: {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .foregroundColor(Color("buttonColor"))
                        })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 5)
                .padding(.horizontal, 50)
                
                // インポート済み音楽を再生する画面への導線
                HStack {
                    Button(action: {
                        self.appState.musicObject.musicInteractor.fetchAlbums(appState: self.appState)
                        self.appState.sheetObject.isShowAlbumSheet.toggle()
                    }, label: {
                        VStack {
                            Image(systemName: "rectangle.stack.fill")
                                .resizable()
                                .frame(maxWidth: 50, maxHeight: 50)
                                .foregroundColor(Color("textColor"))
                            Text("アルバム")
                                .bold()
                                .font(.title2)
                                .foregroundColor(Color("textColor"))
                            Text("から選択")
                                .foregroundColor(Color("textColor"))
                            
                        }
                    })
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color("buttonColor"))
                    .cornerRadius(30)
                    .sheet(isPresented: self.$appState.sheetObject.isShowAlbumSheet) {
                        AlbumPickView()
                            .presentationContentInteraction(.scrolls)
                    }
                    Spacer()
                    Button(action: {
                        self.appState.musicObject.musicInteractor.fetchPlayLists(appState: self.appState)
                        self.appState.sheetObject.isShowPlayListSheet.toggle()
                    }, label: {
                        VStack {
                            Image(systemName: "music.note.list")
                                .resizable()
                                .frame(maxWidth: 50, maxHeight: 50)
                                .foregroundColor(Color("textColor"))
                            Text("プレイリスト")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color("textColor"))
                            Text("から選択")
                                .foregroundColor(Color("textColor"))
                            
                        }
                    })
                    .padding(15)
                    .background(Color("buttonColor"))
                    .cornerRadius(30)
                    .sheet(isPresented: self.$appState.sheetObject.isShowPlayListSheet) {
                        PlayListPickView()
                            .presentationContentInteraction(.scrolls)
                    }
                }
                .padding(.horizontal, 50)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
