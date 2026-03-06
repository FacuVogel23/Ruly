//
//  ContentView.swift
//  Streakly
//
//  Created by Facundo Vogel on 28/02/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HabitListView()
                .navigationTitle("Streakly")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            //AddHabitView con NavigationLink
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)

    let habit1 = Habit(name: "Practice Guitar", habitDescription: "30 minutes daily", difficulty: .easy)
    let habit2 = Habit(name: "Read", habitDescription: "At least 20 pages", difficulty: .medium)
    let habit3 = Habit(name: "Work out", habitDescription: "Gym or home workout", difficulty: .hard)

    container.mainContext.insert(habit1)
    container.mainContext.insert(habit2)
    container.mainContext.insert(habit3)

    return ContentView()
        .modelContainer(container)
}
