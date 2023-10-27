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
        LazyVGrid(columns: columns) {
            ForEach(appState.musicObject.albums, id: \.self) { album in
                VStack {
                    if let artwork = album.items.first?.artwork {
                        Image(uiImage: artwork.image(at: CGSize(width: 30, height: 30))!)
                    }
                    Text("\(album.representativeItem?.albumTitle ?? "No Title")")
                }
                .onTapGesture(count: 1) {
                    self.appState.musicObject.album = album
                    self.appState.sheetObject.isShowAlbumSheet.toggle()
                }
            }
        }
    }
}
