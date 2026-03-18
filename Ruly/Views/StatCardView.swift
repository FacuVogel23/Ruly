//
//  StatCardView.swift
//  Ruly
//
//  Created by Facundo Vogel on 17/03/2026.
//

import SwiftUI

struct StatCardView: View {
    let systemImage: String
    let value: Int
    let label: String
    
    var body: some View {
        
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .foregroundStyle(Color.rulyTeal)
            
            Text("\(value)")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
                .animation(.default, value: value)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.rulyCard, in: RoundedRectangle(cornerRadius: 12))
        
    }
}

#Preview {
    StatCardView(systemImage: "flame.fill", value: 4, label: "Streak")
}
