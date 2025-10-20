//
//  ClueService.swift
//  BramptonScavengerHunt
//

import Foundation

final class ClueService {
    static let shared = ClueService()
    private init() {}
    
    /// Returns mock clues locally (no API)
    func fetchClues() async throws -> [Clue] {
        print("📍 Loaded \(MockData.clues.count) mock clues locally.")
        return MockData.clues
    }
}
