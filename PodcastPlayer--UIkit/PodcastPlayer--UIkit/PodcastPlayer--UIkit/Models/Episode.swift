//
//  Episode.swift
//  PodcastPlayer--UIkit
//
//  Created by zhang on 23/05/2025.
//

import Foundation

struct Episode: Codable {
    let id: String
    let title: String
    let description: String
    let imageURL: String?
    let publishDate: Date
    let duration: TimeInterval
    let podcastTitle: String
    var isDownloaded: Bool
    var localFileURL: String?
    var playbackPosition: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, imageURL, publishDate, duration, podcastTitle, isDownloaded, localFileURL, playbackPosition
    }
    
    init(id: String, title: String, description: String, imageURL: String?, publishDate: Date, duration: TimeInterval, podcastTitle: String, isDownloaded: Bool, localFileURL: String? = nil, playbackPosition: TimeInterval) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.publishDate = publishDate
        self.duration = duration
        self.podcastTitle = podcastTitle
        self.isDownloaded = isDownloaded
        self.localFileURL = localFileURL
        self.playbackPosition = playbackPosition
    }
}
