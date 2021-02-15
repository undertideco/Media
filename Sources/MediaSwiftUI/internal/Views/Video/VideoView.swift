//
//  VideoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !os(macOS)
import AVFoundation
import AVKit
import MediaCore
import SwiftUI

@available(iOS 13, macOS 10.15, tvOS 13, *)
struct VideoView: View {
    @State private var state: ViewState<AVPlayerItem> = .loading

    let video: Video

    var body: some View {
        switch state {
        case .loading:
            UniversalProgressView()
                .onAppear(perform: fetchPlayerItem)
        case .loaded(let item):
            if #available(iOS 15, *) {
                let player = AVPlayer(playerItem: item)

                VideoPlayer(player: player)
                    .onDisappear {
                        player.pause()
                        state = .loading
                    }
            } else {
                let player = AVPlayerView(avPlayerItem: item)

                player
                    .onDisappear {
                        player.pause()
                        state = .loading
                    }
            }
        case .failed(let error):
            Text(error.localizedDescription)
                .onDisappear {
                    state = .loading
                }
        }
    }
}

@available(iOS 13, macOS 10.15, tvOS 13, *)
private extension VideoView {
    func fetchPlayerItem() {
        guard state == .loading else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            video.playerItem { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let avPlayerItem):
                        state = .loaded(value: avPlayerItem)
                    case .failure(let error):
                        state = .failed(error: error)
                    }
                }
            }
        }
    }
}
#endif
