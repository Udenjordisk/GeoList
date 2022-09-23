//
//  GeoListApp.swift
//  GeoList
//
//  Created by Кирилл on 28.08.2022.
//

import SwiftUI

@main
struct GeoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //LaunchScreenView()
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
