//
//  HabitViewModel.swift
//  Streakly
//
//  Created by Facundo Vogel on 06/03/2026.
//

import SwiftData

@Observable
class HabitViewModel {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addHabit(name: String, description: String, difficulty: Difficulty) {
        let habit = Habit(name: name, habitDescription: description, difficulty: difficulty)
        
        modelContext.insert(habit)
    }
    
}
