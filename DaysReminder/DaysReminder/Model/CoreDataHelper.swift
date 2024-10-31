//
//  CoreDataHelper.swift
//  DaysReminder
//
//  Created by zhang on 31/10/2024.
//  Help managing save/fetch/delete behaviors

import CoreData
import SwiftUI

class CoreDataHelper {
    static let shared = CoreDataHelper()
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "DaysReminderModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading Core Data: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    //Fetch reminders
    func fetchAllEntries() -> [DateEntry] {
        let request = DateEntry.fetchRequest() as! NSFetchRequest<DateEntry>
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch entries: \(error)")
            return []
        }
    }
    
    //Delete
    func deleteEntry(_ entry: DateEntry) {
        context.delete(entry)
        saveContext()
    }
}

