//
//  BikeDashboardApp.swift
//  BikeDashboard
//
//  Created by Mate Granic on 04.12.2023..
//

import SwiftUI
import SwiftData

@main
struct BikeDashboardApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen()
        }
        .modelContainer(for: [SettingsModel.self])
    }
}
    
