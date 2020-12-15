//
//  VideoView.swift
//  CarouselExperiment
//
//  Created by Jonathan Menard on 2020-12-08.
//  Copyright © 2020 Jonathan Menard. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

private extension CGFloat {
    static let videoImageRatio: CGFloat = 1.5
    static let fractionalProgressBarHeight: CGFloat = 0.02
}


struct VideoCarouselItem: Hashable {
    let title: String
    let imageUrl: URL?
}

struct VideoView: View {
    let item: VideoCarouselItem

    let scaleRatio: (GeometryProxy) -> CGFloat
    let opacityRatio: (GeometryProxy) -> Double
    let onVideoTap: (GeometryProxy, VideoCarouselItem) -> Void
    let minimumScaleFraction: CGFloat

    var body: some View {
        GeometryReader { geoProxy in
            VStack {
                self.videoTile(geoProxy: geoProxy)
                self.videoTitle
            }
            .scaleEffect(self.scaleRatio(geoProxy))
            .opacity(self.opacityRatio(geoProxy))
            .animation(.default)
        }
    }

    private func videoTile(geoProxy: GeometryProxy) -> some View {
        Button(action: { self.onVideoTap(geoProxy, self.item)}) {
            ZStack(alignment: .bottomLeading) {
                WebImage(url: self.item.imageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geoProxy.size.width, height: geoProxy.size.width / .videoImageRatio)
                Image(systemName: "play.circle")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .padding(10)
            }
            .background(Color.blue)
            .clipped()
            .cornerRadius(2)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var videoTitle: some View {
        Text(self.item.title)
            .minimumScaleFactor(0.5)
    }
}
