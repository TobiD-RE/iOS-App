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
    let audioURL: String
    let imageURL: String?
    let publishDate: Date
    let duration: TimeInterval
    let podcastTitle: String
    var isDownloaded: Bool
    var localFileURL: String?
    var playbackPosition: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, audioURL, imageURL, publishDate, duration, podcastTitle, isDownloaded, localFileURL, playbackPosition
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        audioURL = try container.decode(String.self, forKey: .audioURL)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        publishDate = try container.decode(Date.self, forKey: .publishDate)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        podcastTitle = try container.decode(String.self, forKey: .podcastTitle)
        isDownloaded = try container.decodeIfPresent(Bool.self, forKey: .isDownloaded) ?? false
        localFileURL = try container.decodeIfPresent(String.self, forKey: .localFileURL)
        playbackPosition = try container.decodeIfPresent(TimeInterval.self, forKey: .playbackPosition) ?? 0
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(audioURL, forKey: .audioURL)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(publishDate, forKey: .publishDate)
        try container.encode(duration, forKey: .duration)
        try container.encode(podcastTitle, forKey: .podcastTitle)
        try container.encode(isDownloaded, forKey: .isDownloaded)
        try container.encode(localFileURL, forKey: .localFileURL)
        try container.encode(playbackPosition, forKey: .playbackPosition)
    }
}
