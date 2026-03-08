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
            Form {
                TextField("Insert name", text: $name)
                
                TextField("Insert description", text: $description)
                
                Section("Select difficulty"){
                    Picker("Select difficulty", selection: $difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .status) {
                    Button("Save") {
                        let habit = Habit(name: name.trimmingCharacters(in: .whitespaces), habitDescription: description.trimmingCharacters(in: .whitespaces), difficulty: difficulty)
                        modelContext.insert(habit)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
}

#Preview {
    AddHabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}
