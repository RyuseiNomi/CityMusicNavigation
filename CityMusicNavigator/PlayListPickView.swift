//
//  PlayListPickView.swift
//  CityMusicNavigator
//
//  Created by とんと on 2023/10/28.
//

import SwiftUI
import MusicKit
import MediaPlayer

struct PlayListPickView: View {
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @EnvironmentObject public var appState: AppState
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(self.appState.musicObject.playLists, id: \.self) { playList in
                VStack {
                    if let artwork = playList.items.first?.artwork {
                        Image(uiImage: artwork.image(at: CGSize(width: 30, height: 30))!)
                    }
                    if let representativeItem = playList.representativeItem {
                        Text(representativeItem.albumTitle!)
                    }
                }
                .onTapGesture(count: 1) {
                    self.appState.musicObject.playList = playList
                    // 既にアルバムが選択されていた場合に、アルバムの曲が再生されるのを防ぐため
                    self.appState.musicObject.album = nil
                    self.appState.sheetObject.isShowPlayListSheet.toggle()
                }
            }
        }
    }
}
