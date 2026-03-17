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
        
        VStack {
            Image(systemName: systemImage)
            
            Text("\(value)")
                .font(.title)
                .bold()
                .animation(.default, value: value)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    StatCardView(systemImage: "flame.fill", value: 4, label: "Streak")
}
