//
//  DataModel.swift
//  PodWave
//
//  Created by zhang on 18/05/2025.
//

import Foundation

struct Podcast: Identifiable, Codable {
    var id: String
    var title: String
    var author: String
    var description: String
    var imageUrl: String
    var feedUrl: String
    var episodes: [Episode]?
}

struct Episode: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var publicationDate: Date
    var durationL: TimeInterval
    var audioUrl: String
    var imageUrl: String?
    var isDownloaded: Bool = false
    var playbackPosition: TimeInterval = 0
}
