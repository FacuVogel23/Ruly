//
//  HabitDetailView.swift
//  Ruly
//
//  Created by Facundo Vogel on 07/03/2026.
//

import SwiftUI

struct HabitDetailView: View {
    let habit: Habit
    @State private var viewModel = HabitViewModel()
    
    var body: some View {
        
        VStack {
            Spacer()
            
            VStack(spacing: 32) {
                
                VStack(alignment: .center, spacing: 8) {
                    Text(habit.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(habit.habitDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(habit.difficulty.name)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(habit.difficulty.color, in: Capsule())
                }
                
                HabitStatsView(streak: viewModel.habitStreak(habit),
                               score: viewModel.habitScore(habit),
                               completions:habit.completionDates.count)
                
                Button {
                    viewModel.completeHabit(habit)
                } label: {
                    Text(viewModel.isCompletedToday(habit) ? "Completed today ✓" : "Mark as complete")
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .background(viewModel.isCompletedToday(habit) ? Color.secondary : Color.rulyTeal,
                            in: RoundedRectangle(cornerRadius: 25))
                .disabled(viewModel.isCompletedToday(habit))
                .animation(.default, value: viewModel.isCompletedToday(habit))
            }
            .padding()
            
            Spacer()
        }
        
    }
    
}

#Preview {
    let habit = Habit(name: "hola", habitDescription: "hola descripcion", difficulty: .easy)
    
    HabitDetailView(habit: habit)
}
