//
//  AddHabitView.swift
//  Ruly
//
//  Created by Facundo Vogel on 07/03/2026.
//

import SwiftData
import SwiftUI

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var difficulty = Difficulty.easy
    
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color.rulyBackground.gradient)
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.6))
                            
                            ZStack(alignment: .leading) {
                                  if name.isEmpty {
                                      Text("e.g. Morning Run")
                                          .foregroundStyle(.white.opacity(0.4))
                                          .padding(.horizontal, 4)
                                  }
                                  TextField("", text: $name)
                                      .foregroundStyle(.white)
                              }
                            .padding()
                            .background(Color.rulyCard, in: RoundedRectangle(cornerRadius: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.6))
                            
                            ZStack(alignment: .leading) {
                                  if description.isEmpty {
                                      Text("e.g. 30 minutes daily")
                                          .foregroundStyle(.white.opacity(0.4))
                                          .padding(.horizontal, 4)
                                  }
                                  TextField("", text: $description)
                                      .foregroundStyle(.white)
                              }
                            .padding()
                            .background(Color.rulyCard, in: RoundedRectangle(cornerRadius: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Difficulty")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.6))
                            
                            HStack(spacing: 10) {
                                  ForEach(Difficulty.allCases, id: \.self) { dif in
                                      Button(dif.name) {
                                          difficulty = dif
                                      }
                                      .frame(maxWidth: .infinity)
                                      .padding(.vertical, 5)
                                      .background(difficulty == dif ? dif.color : Color.rulyCard,
                                                  in: RoundedRectangle(cornerRadius: 20))
                                      .foregroundStyle(.white)
                                  }
                              }
                        }
                        
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                          Text("New Habit")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                      }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let habit = Habit(name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                          habitDescription: description.trimmingCharacters(in: .whitespacesAndNewlines),
                                          difficulty: difficulty)
                        modelContext.insert(habit)
                        dismiss()
                    } label: {
                        Text("Save")
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.rulyTeal)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.rulyTeal)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.rulyCard)
                }
            }
        }
        .preferredColorScheme(.dark)
        
    }
    
}

#Preview {
    AddHabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}
