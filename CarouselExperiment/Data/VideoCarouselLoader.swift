//
//  VideoCarouselLoader.swift
//  CarouselExperiment
//
//  Created by Jonathan Menard on 2020-12-08.
//  Copyright © 2020 Jonathan Menard. All rights reserved.
//

import Foundation

final class VideoCarouselLoader: ObservableObject {
    @Published var videos: [VideoCarouselItem] = [
        .init(title: "1", imageUrl: URL(string: "https://source.unsplash.com/random?sig=1")),
        .init(title: "2", imageUrl: URL(string: "https://source.unsplash.com/random?sig=2")),
        .init(title: "3", imageUrl: URL(string: "https://source.unsplash.com/random?sig=3")),
        .init(title: "4", imageUrl: URL(string: "https://source.unsplash.com/random?sig=4")),
        .init(title: "5", imageUrl: URL(string: "https://source.unsplash.com/random?sig=5"))
    ]

    @Published var selectedVideo: VideoCarouselItem? = nil

    func select(_ video: VideoCarouselItem) {
        selectedVideo = video
    }
}
