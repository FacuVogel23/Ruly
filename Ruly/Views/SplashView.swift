//
//  SplashView.swift
//  Ruly
//
//  Created by Facundo Vogel on 25/03/2026.
//

import SwiftUI

struct SplashView: View {
    @State private var opacity = 0.0
    @State private var scale = 0.85
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.rulyBackground.gradient)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Color.rulyTeal)
                
                Text("Ruly")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    opacity = 1.0
                    scale = 1.0
                }
            }
            
        }
    }
}

#Preview {
    SplashView()
}
