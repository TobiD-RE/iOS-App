//
//  DateEntry.swift
//  DaysReminder
//
//  Created by zhang on 31/10/2024.
//  Represents each event/reminder, holding data


import Foundation
import CoreData

@objc(DateEntry)
public class DateEntry: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var isAnniversary: Bool
    @NSManaged public var tag: String
    @NSManaged public var createDate: Date
    @NSManaged public var notificationEnabled: Bool
    @NSManaged public var notificationTime: Date?
    
    convenience init(context: NSManagedObjectContext, title: String, date: Date, isAnniversary: Bool, tag: String, createDate: Date, notificationEnabled: Bool, notificationTime: Date? = nil) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.date = date
        self.isAnniversary = isAnniversary
        self.tag = tag
        self.createDate = createDate
        self.notificationEnabled = notificationEnabled
        self.notificationTime = notificationTime
    }
    
    var daysUntil: Int {
        let calendar = Calendar.current
        let now = Date()
        guard let days = calendar.dateComponents([.day], from: now, to: date).day
        else {return 0}
        return days
    }
    
    var daysSince: Int {
        let calendar = Calendar.current
        let now = Date()
        guard let days = calendar.dateComponents([.day], from: date, to: now).day
        else {return 0}
        return days
    }
}

