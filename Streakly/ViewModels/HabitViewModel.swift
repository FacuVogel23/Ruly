//
//  HabitViewModel.swift
//  Ruly
//
//  Created by Facundo Vogel on 06/03/2026.
//

import Foundation
import SwiftData

@Observable
class HabitViewModel {
    
    func isCompletedToday(_ habit: Habit) -> Bool {
        habit.completionDates.contains { Calendar.current.isDateInToday($0) }
    }
    
    func completeHabit(_ habit: Habit) {
        habit.completionDates.append(Date.now)
    }
    
    func habitScore(_ habit: Habit) -> Int {
        habit.completionDates.count * habit.difficulty.rawValue
    }
    
    func habitStreak(_ habit: Habit) -> Int {
        var streakDays = 0
        var checkDay = Calendar.current.startOfDay(for: Date.now)
        
        let completionDays = habit.completionDates.map { Calendar.current.startOfDay(for: $0) }
        
        let setCompletionDays = Set(completionDays)
        
        if setCompletionDays.contains(checkDay) == false {
            if let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: checkDay) {
                checkDay = previousDay
            }
        }
        
        while setCompletionDays.contains(checkDay) {
            streakDays += 1
            
            if let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: checkDay) {
                checkDay = previousDay
            } else {
                break
            }
        }
        
        return streakDays
    }
    
}
