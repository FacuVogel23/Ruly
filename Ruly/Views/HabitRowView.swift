//
//  HabitRowView.swift
//  Ruly
//
//  Created by Facundo Vogel on 15/03/2026.
//

import SwiftUI

struct HabitRowView: View {
    let viewModel: HabitViewModel
    let habit: Habit
    
    var body: some View {
        
        HStack(spacing: 12) {
            Image(systemName: viewModel.isCompletedToday(habit) ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(viewModel.isCompletedToday(habit) ? Color.rulyTeal : .white.opacity(0.4))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(habit.habitDescription)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
                
            Text(habit.difficulty.name)
                .font(.caption)
                .bold()
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(habit.difficulty.color, in: Capsule())
        }
        
    }
}

#Preview {
    HabitRowView(viewModel: HabitViewModel(), habit: Habit(name: "prueba", habitDescription: "descripcion prueba", difficulty: .easy))
}
