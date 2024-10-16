//
//  Little_LemonApp.swift
//  Little Lemon
//
//  Created by Garima Bhala on 2024-09-18.
//

import SwiftUI

@main
struct Little_LemonApp: App {
    let persistenceContainer = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            Onboarding()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
