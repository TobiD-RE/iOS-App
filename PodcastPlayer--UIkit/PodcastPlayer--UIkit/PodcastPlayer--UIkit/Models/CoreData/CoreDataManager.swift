//
//  CoreDataManager.swift
//  PodcastPlayer--UIkit
//
//  Created by zhang on 26/05/2025.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistenContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PodcastPlayer")
        container.loadPersistentStores{ _, error in
            if let error = error {
                fatalError("Core data error: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistenContainer.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save sontext: \(error)")
            }
        }
    }
    
    func savePodcast(_ podcast: Podcast) {
        save()
    }
    
    func fetchSubscribedPodcasts() -> [Podcast] {
        return []
    }
    
    func deletePodcast(withId id: String) {
        save()
    }
    
    func saveEpisode(_ episode: Episode){
        save()
    }
    
    func updateEpisodePlaybackPosition(_ episodeId: String, position: TimeInterval) {
        save()
    }
    
    func fetchDownloadedEpisodes() -> [Episode] {
        return []
    }
}
