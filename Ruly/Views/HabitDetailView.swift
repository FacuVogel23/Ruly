//
//  HabitDetailView.swift
//  Ruly
//
//  Created by Facundo Vogel on 07/03/2026.
//

import SwiftUI

struct HabitDetailView: View {
    let  viewModel: HabitViewModel
    let habit: Habit
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .fill(Color.rulyBackground.gradient)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 32) {
                    
                    VStack(alignment: .center, spacing: 8) {
                        Text(habit.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(habit.habitDescription)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                        
                        Text(habit.difficulty.name)
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(habit.difficulty.color, in: Capsule())
                            .padding(.top, 10)
                    }
                    
                    HabitStatsView(streak: viewModel.habitStreak(habit),
                                   score: viewModel.habitScore(habit),
                                   completions:habit.completionDates.count)
                    
                    Button {
                        if !viewModel.isCompletedToday(habit) {
                            withAnimation {
                                viewModel.completeHabit(habit)
                            }
                        }
                    } label: {
                        Text(viewModel.isCompletedToday(habit) ? "Completed today ✓" : "Mark as complete")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(viewModel.isCompletedToday(habit) ? Color.rulyCard : .rulyTeal)
                    .controlSize(.large)
                    .opacity(viewModel.isCompletedToday(habit) ? 0.7 : 1.0)
                    .animation(.default, value: viewModel.isCompletedToday(habit))
                }
                .padding()
                
                Spacer()
            }
        }
        
    }
    
}

#Preview {
    let habit = Habit(name: "hola", habitDescription: "hola descripcion", difficulty: .easy)
    
    HabitDetailView(viewModel: HabitViewModel(), habit: habit)
}
