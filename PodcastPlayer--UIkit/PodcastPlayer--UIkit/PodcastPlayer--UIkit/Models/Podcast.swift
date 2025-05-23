//
//  Podcast.swift
//  PodcastPlayer--UIkit
//
//  Created by zhang on 23/05/2025.
//

import Foundation

struct Podcast: Codable {
    let id: String
    let title: String
    let description: String
    let imageURL: String
    let feedURL: String
    let author: String
    let episodes: [Episode]?
    let isSubscribed: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "collectionId"
        case title = "collectionName"
        case description
        case imageURL
        case feedURL
        case author
        case episodes
        case isSubscribed
    }
    
    init(from decode: Decoder) throws {
        let container = try decode.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        imageURL = try container.decode(String.self, forKey: .imageURL)
        feedURL = try container.decode(String.self, forKey: .feedURL)
        author = try container.decode(String.self, forKey: .author)
        episodes = try container.decode([Episode].self, forKey: .episodes)
        isSubscribed = try container.decode(Bool.self, forKey: .isSubscribed) ?? false
    }
}
