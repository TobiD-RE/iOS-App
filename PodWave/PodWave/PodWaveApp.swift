//
//  PodWaveApp.swift
//  PodWave
//
//  Created by zhang on 18/05/2025.
//

import SwiftUI

@main
struct PodWaveApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
