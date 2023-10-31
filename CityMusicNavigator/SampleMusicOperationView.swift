//
//  SampleMusicOperationView.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/31.
//

import SwiftUI
import AVFoundation

struct SampleMusicOperationView: View {
    
    @EnvironmentObject public var appState: AppState
    var player: AVAudioPlayer?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 再生中の曲の情報
                VStack {
                    Image("jacket")
                        .resizable()
                        .frame(maxWidth: 150, maxHeight: 150)
                        .padding(.bottom, 0)
                    Text("アルバムもしくはプレイリストから\n曲を選択してください")
                        .padding(.top, 10)
                        .padding(.bottom, 0)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2)
                
                // 音楽操作パネル
                Grid {
                    GridRow {
                        Button(action: {
                            self.appState.musicObject.currentSampleSong?.stop()
                            if self.appState.musicObject.currentSamplePlayNumber > 1 {
                                self.appState.musicObject.currentSamplePlayNumber -= 1
                            }
                            appState.musicObject.currentSampleSong = try? AVAudioPlayer(contentsOf: self.appState.musicObject.samplePlayList[self.appState.musicObject.currentSamplePlayNumber])
                            self.appState.musicObject.currentSampleSong?.play()
                        }, label: {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .foregroundColor(Color("buttonColor"))
                        })
                        Spacer()
                        if self.appState.musicObject.isPlayingMusic {
                            Button(action: {
                                self.appState.musicObject.currentSampleSong?.pause()
                            }, label: {
                                Image(systemName: "pause.circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 70, maxHeight: 70)
                                    .foregroundColor(Color("buttonColor"))
                                
                            })
                        } else {
                            Button(action: {
                                self.appState.musicObject.currentSampleSong?.play()
                            }, label: {
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 70, maxHeight: 70)
                                    .foregroundColor(Color("buttonColor"))
                            })
                        }
                        Spacer()
                        Button(action: {
                            self.appState.musicObject.currentSampleSong?.stop()
                            if self.appState.musicObject.currentSamplePlayNumber < self.appState.musicObject.samplePlayList.count - 1 {
                                self.appState.musicObject.currentSamplePlayNumber += 1
                            }
                            appState.musicObject.currentSampleSong = try? AVAudioPlayer(contentsOf: self.appState.musicObject.samplePlayList[self.appState.musicObject.currentSamplePlayNumber])
                            self.appState.musicObject.currentSampleSong?.play()
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
                        HStack {
                            Image(systemName: "music.note.list")
                                .resizable()
                                .frame(maxWidth: 50, maxHeight: 50)
                                .foregroundColor(Color("textColor"))
                            VStack {
                                Text("iPhoneにある音楽")
                                    .bold()
                                    .font(.title2)
                                    .foregroundColor(Color("textColor"))
                                Text("から選択する")
                                    .foregroundColor(Color("textColor"))
                            }
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
