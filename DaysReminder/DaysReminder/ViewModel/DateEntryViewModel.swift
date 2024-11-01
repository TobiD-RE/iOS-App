//
//  DateEntryViewModel.swift
//  DaysReminder
//
//  Created by zhang on 01/11/2024.
//
//  Fetch and update DateEntry objects
//  Provide sorting and filtering functions
//  Use Combine to make data reactive and update views accordingly

import Foundation
import Combine
import CoreData

enum SortOption {
    case chronological
    case byCreationDate
}

class DateEntryViewModel: ObservableObject {
    // Published properties for UI bindings
    
    @Published var dateEntries: [DateEntry] = []
    @Published var sortOption: SortOption = .chronological
    @Published var filterTag: String? = nil
    
    private let coreDataHelper = CoreDataHelper.shared
    private let notificationManager = NotificationManager.shared
    
    // Initialize and load entries
    
    init() {
        notificationManager.requestNotificationPermission()
        fetchEntries()
    }
    
    //Fetch all entries, applying sorting and filtering
    func fetchEntries() {
        let allEntries = coreDataHelper.fetchAllEntries()
        
        // Applying tag if any
        let filteredEntries = filterTag != nil ? allEntries.filter { $0.tag == filterTag } : allEntries
        
        // Sort based on selected option
        switch sortOption {
        case .chronological:
            dateEntries = filteredEntries.sorted { $0.date < $1.date}
        case .byCreationDate:
            dateEntries = filteredEntries.sorted { $0.createDate < $1.createDate}
        }
    }
    
    // Add
    
    func addEntry(title: String, date: Date, isAnniversary: Bool, tag: String, notificationEnabled: Bool, notificationTime: Date?) {
        let newEntry = DateEntry(context: coreDataHelper.context, title: title, date: date, isAnniversary: isAnniversary, tag: tag, createDate: Date(), notificationEnabled: notificationEnabled, notificationTime: notificationTime)
        
        coreDataHelper.saveContext()
        fetchEntries()
        
        if notificationEnabled {
            notificationManager.scheduleNotification(for: newEntry)
        }
    }
    
    //Update
    
    func updateEntry(_ entry: DateEntry, title: String, date: Date, isAnniversary: Bool, tag: String, notificationEnabled: Bool, notificationTime: Date?) {
        entry.title = title
        entry.date = date
        entry.isAnniversary = isAnniversary
        entry.tag = tag
        entry.notificationEnabled = notificationEnabled
        entry.notificationTime = notificationTime
        
        coreDataHelper.saveContext()
        fetchEntries()
        
        notificationManager.updateNotification(for: entry)
        }
    
    //Delete
    
    func deleteEntry(_ entry: DateEntry) {
        notificationManager.cancelNotification(for: entry)
        coreDataHelper.deleteEntry(entry)
        fetchEntries()
    }
    
    //Change sorting option
    
    func changeSortOption(to option: SortOption) {
        sortOption = option
        fetchEntries()
    }
    
    //Fitler
    
    func filterEntries(by tag: String?) {
        filterTag = tag
        fetchEntries()
    }
    
    //Clear tag
    
    func clearFilter() {
        filterTag = nil
        fetchEntries()
    }
}

