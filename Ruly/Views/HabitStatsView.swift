//
//  HabitStatsView.swift
//  Ruly
//
//  Created by Facundo Vogel on 17/03/2026.
//

import SwiftUI

struct HabitStatsView: View {
    let streak: Int
    let score: Int
    let completions: Int
    
    var body: some View {
        
        HStack {
            StatCardView(systemImage: "flame.fill", value: streak, label: "Streak")
            
            StatCardView(systemImage: "star.fill", value: score, label: "Score")
            
            StatCardView(systemImage: "checkmark.circle.fill", value: completions, label: "Total")
        }
        
    }
}

#Preview {
    HabitStatsView(streak: 4, score: 12, completions: 10)
}
