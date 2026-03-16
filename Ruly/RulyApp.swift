//
//  RulyApp.swift
//  Ruly
//
//  Created by Facundo Vogel on 28/02/2026.
//

import SwiftUI
import SwiftData

@main
struct RulyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Habit.self)
    }
}
