//
//  Habit.swift
//  Ruly
//
//  Created by Facundo Vogel on 04/03/2026.
//

import Foundation
import SwiftData

@Model
class Habit {
    var name: String
    var habitDescription: String
    var difficulty: Difficulty
    var completionDates: [Date] = []
    var createdAt: Date = Date.now
    
    init(name: String, habitDescription: String, difficulty: Difficulty) {
        self.name = name
        self.habitDescription = habitDescription
        self.difficulty = difficulty
    }
}
