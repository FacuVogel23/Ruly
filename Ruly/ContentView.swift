//
//  ContentView.swift
//  Ruly
//
//  Created by Facundo Vogel on 28/02/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var viewModel = HabitViewModel()
    @State private var showingAddHabitView = false
    
    var body: some View {
        NavigationStack {
            HabitListView(viewModel: viewModel)
                .navigationTitle("Ruly")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add habit", systemImage: "plus") {
                            showingAddHabitView.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.rulyTeal)
                    }
                }
                .sheet(isPresented: $showingAddHabitView) {
                    AddHabitView()
                }
        }
    }
}

#Preview {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try! ModelContainer(for: Habit.self, configurations: config)
      let _ = {
          container.mainContext.insert(Habit(name: "Practice Guitar", habitDescription: "30 minutes daily", difficulty: .easy))
          container.mainContext.insert(Habit(name: "Read", habitDescription: "At least 20 pages", difficulty: .medium))
          container.mainContext.insert(Habit(name: "Work out", habitDescription: "Gym or home workout", difficulty: .hard))
      }()
      ContentView()
          .modelContainer(container)
  }
