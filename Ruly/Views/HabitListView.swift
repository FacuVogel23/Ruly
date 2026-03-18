//
//  HabitListView.swift
//  Ruly
//
//  Created by Facundo Vogel on 04/03/2026.
//

import SwiftData
import SwiftUI

struct HabitListView: View {
    let  viewModel: HabitViewModel
    
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    
    
    var body: some View {
        
            List {
                ForEach(habits) { habit in
                    ZStack(alignment: .leading) {
                        NavigationLink(value: habit) { EmptyView() }
                            .opacity(0)
                        HabitRowView(viewModel: viewModel, habit: habit)
                            .padding(12)
                            .background(Color.rulyCard, in: RoundedRectangle(cornerRadius: 15))
                            .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                }
                .onDelete(perform: deleteHabit)
            }
            .scrollContentBackground(.hidden)
            .background(
                Rectangle()
                    .fill(Color.rulyBackground.gradient).ignoresSafeArea()
            )
            .navigationDestination(for: Habit.self) { habit in
                HabitDetailView(viewModel: viewModel, habit: habit)
            }
            .overlay {
                if habits.isEmpty {
                    ContentUnavailableView("No habits yet", systemImage: "checklist", description: Text("Tap + to add your first habit"))
                        .preferredColorScheme(.dark)
                }
            }
            .toolbar {
                if !habits.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                            .buttonStyle(.borderedProminent)
                            .tint(Color.rulyCard)
                    }
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
      let _ = {
          container.mainContext.insert(Habit(name: "Practice Guitar", habitDescription: "30 minutes daily", difficulty: .easy))
          container.mainContext.insert(Habit(name: "Read", habitDescription: "At least 20 pages", difficulty: .medium))
          container.mainContext.insert(Habit(name: "Work out", habitDescription: "Gym or home workout", difficulty: .hard))
      }()
      HabitListView(viewModel: HabitViewModel())
          .modelContainer(container)
  }
