//
//  ClueListView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

//
//  ClueListView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

import SwiftUI

struct ClueListView: View {
    @State private var clues: [Clue] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading Clues…")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(clues, id: \.id) { clue in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(clue.name ?? "Unnamed Clue")
                                .font(.headline)
                            
                            Text(clue.hint ?? "No hint available")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("📍 \(clue.location ?? "Unknown location")")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Scavenger Hunt")
            .task {
                await loadClues()
            }
        }
    }
    
    private func loadClues() async {
        do {
            clues = try await ClueService.shared.fetchClues()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}



