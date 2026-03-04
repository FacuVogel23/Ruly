//
//  StreaklyApp.swift
//  Streakly
//
//  Created by Facundo Vogel on 28/02/2026.
//

import SwiftUI
import SwiftData

@main
struct StreaklyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Habit.self)
    }
}
