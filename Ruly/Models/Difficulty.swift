//
//  Difficulty.swift
//  Ruly
//
//  Created by Facundo Vogel on 04/03/2026.
//

import SwiftUI

enum Difficulty: Int, CaseIterable, Codable {
    case easy = 1
    case medium = 3
    case hard = 5
    
    var name: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
    
    var color: Color {
        switch self {
            case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
    
}
