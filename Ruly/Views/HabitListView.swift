//
//  HabitListView.swift
//  Ruly
//
//  Created by Facundo Vogel on 04/03/2026.
//

import SwiftData
import SwiftUI

struct HabitListView: View {
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        
        if habits.isEmpty {
            ContentUnavailableView("No habits yet", systemImage: "checklist", description: Text("Tap + to add your first habit"))
        } else {
            List {
                ForEach(habits) { habit in
                    NavigationLink(value: habit) {
                        HabitRowView(habit: habit)
                    }
                }
                .onDelete(perform: deleteHabit)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .navigationDestination(for: Habit.self) { habit in
                HabitDetailView(habit: habit)
            }
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        for offset in offsets {
            let habit = habits[offset]
            
            modelContext.delete(habit)
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

    return HabitListView()
        .modelContainer(container)
}
