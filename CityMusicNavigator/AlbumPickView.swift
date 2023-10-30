//
//  AlbumPickView.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/28.
//

import SwiftUI
import MusicKit

struct AlbumPickView: View {
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @EnvironmentObject public var appState: AppState
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(appState.musicObject.albums, id: \.self) { album in
                    VStack {
                        if let artwork = album.items.first?.artwork {
                            Image(uiImage: artwork.image(at: CGSize(width: 30, height: 30))!)
                        } else {
                            Image("jacket")
                                .resizable()
                                .frame(maxWidth: 100, maxHeight: 100)
                                .padding(.bottom, 0)
                        }
                        Text("\(album.representativeItem?.albumTitle ?? "No Title")")
                    }
                    .onTapGesture(count: 1) {
                        self.appState.musicObject.album = album
                        self.appState.musicObject.currentSong = album.items.first
                        // 既にプレイリストが選択されていた場合に、プレイリストの曲が再生されるのを防ぐため
                        self.appState.musicObject.playList = nil
                        // 再生中の曲と再生位置をリセットする　
                        self.appState.musicObject.isPlayingMusic = false
                        self.appState.musicObject.pauseTime = 0.0
                        self.appState.musicObject.playList = nil
                        self.appState.musicObject.musicPlayer.stop()
                        self.appState.musicObject.musicInteractor.musicPlayer.setQueue(with: album)
                        
                        self.appState.sheetObject.isShowAlbumSheet.toggle()
                    }
                }
            }
        }
    }
}
