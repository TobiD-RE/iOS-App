//
//  Item.swift
//  BabyLog
//
//  Created by zhang on 23/09/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var babyName: String
    var activity: String
    var startTime: Date
    var comment: String
    
    init(babyName: String, activity: String, startTime: Date, comment: String) {
        self.babyName = babyName
        self.activity = activity
        self.startTime = startTime
        self.comment = comment
    }
}
