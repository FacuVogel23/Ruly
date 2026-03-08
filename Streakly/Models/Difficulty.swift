//
//  Difficulty.swift
//  Ruly
//
//  Created by Facundo Vogel on 04/03/2026.
//

import Foundation

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
}
