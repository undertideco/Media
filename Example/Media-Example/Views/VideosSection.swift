//
//  VideosSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct VideosSection: View {
    var body: some View {
        Section {
            if let allVideos = LazyVideos.all {
                NavigationLink(destination: LazyVideosView(videos: allVideos)) {
                    Text("Videos.all (\(allVideos.count))")
                }
            }

            if let highFrameRatesVideos = LazyVideos.highFrameRates {
                NavigationLink(destination: LazyVideosView(videos: highFrameRatesVideos)) {
                    Text("Videos.highFrameRates (\(highFrameRatesVideos.count))")
                }
            }

            if let streamsVideos = LazyVideos.streams {
                NavigationLink(destination: LazyVideosView(videos: streamsVideos)) {
                    Text("Videos.streams (\(streamsVideos.count))")
                }
            }

            if let timelapsesVideos = LazyVideos.timelapses {
                NavigationLink(destination: LazyVideosView(videos: timelapsesVideos)) {
                    Text("Videos.timelapses (\(timelapsesVideos.count))")
                }
            }
        }
    }
}
