//
//  ClueService.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

//
//  ClueService.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

import Foundation

class ClueService {
    static let shared = ClueService()
    
    func fetchClues() async throws -> [Clue] {
        // Instead of calling API, return hardcoded mock data
        return MockData.sampleClues
    }
}

