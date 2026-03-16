//
//  HabitRowView.swift
//  Ruly
//
//  Created by Facundo Vogel on 15/03/2026.
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    @State private var viewModel = HabitViewModel()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(habit.name)
                    .font(.headline)
                
                Text(habit.habitDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Image(systemName: viewModel.isCompletedToday(habit) ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(viewModel.isCompletedToday(habit) ? Color.rulyTeal : Color.secondary)
                
                Text(habit.difficulty.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HabitRowView(habit: Habit(name: "prueba", habitDescription: "descripcion prueba", difficulty: .easy))
}
