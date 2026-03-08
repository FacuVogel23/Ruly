//
//  HabitDetailView.swift
//  Streakly
//
//  Created by Facundo Vogel on 07/03/2026.
//

import SwiftUI

struct HabitDetailView: View {
    let habit: Habit
    @State private var viewModel = HabitViewModel()
    
    var body: some View {
        
        VStack {
            Text(habit.name)
            
            Text(habit.habitDescription)
            
            Text(habit.difficulty.name)
            
            Text("\(habit.completionDates.count)")
            
            Text("\(viewModel.habitScore(habit))")
            
            Text("\(viewModel.habitStreak(habit))")
            
            Button("Mark as complete") {
                viewModel.completeHabit(habit)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isCompletedToday(habit))
        }
    }
    
}

#Preview {
    let habit = Habit(name: "hola", habitDescription: "hola descripcion", difficulty: .easy)
    
    HabitDetailView(habit: habit)
}
