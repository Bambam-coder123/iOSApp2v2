//
//  ClueService.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

import Foundation

final class ClueService {
    static let shared = ClueService()
    private init() {}
    
    // ✅ Your live MockAPI endpoint
    private let baseURL = URL(string: "https://68de927ed7b591b4b79006ab.mockapi.io/api/v1/clue")!
    
    /// Fetches clues from MockAPI or falls back to hardcoded MockData.
    func fetchClues() async throws -> [Clue] {
        do {
            let (data, response) = try await URLSession.shared.data(from: baseURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("⚠️ Server responded with non-200 code")
                return MockData.sampleClues // fallback
            }
            
            let clues = try JSONDecoder().decode([Clue].self, from: data)
            print("✅ Successfully fetched \(clues.count) clues from API")
            return clues
        } catch {
            print("❌ API fetch failed, loading mock data instead: \(error.localizedDescription)")
            return MockData.sampleClues
        }
    }
}



