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
    @State private var isShowingSplash = true
    
    var body: some View {
        ZStack {
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
            .preferredColorScheme(.dark)
            
            if isShowingSplash {
                SplashView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                isShowingSplash = false
                            }
                        }
                    }
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
