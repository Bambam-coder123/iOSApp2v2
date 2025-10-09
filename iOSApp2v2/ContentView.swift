//
//  ContentView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

import SwiftUI

struct ContentView: View {
    @State private var clues: [Clue] = []

    // Persistent found clues using AppStorage
    @AppStorage("foundCluesData") private var foundCluesData: Data = Data()
    
    private var foundClues: Set<String> {
        get {
            (try? JSONDecoder().decode(Set<String>.self, from: foundCluesData)) ?? []
        }
        set {
            foundCluesData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
    
    var body: some View {
        NavigationStack {
            List(clues, id: \.id) { clue in
                NavigationLink(value: clue) {
                    HStack {
                        Text(clue.name)
                            .font(.headline)
                        if foundClues.contains(clue.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationDestination(for: Clue.self) { clue in
                ClueDetailView(clue: clue, foundClues: Binding(
                    get: { foundClues },
                    set: { newValue in
                        // Save new progress whenever it changes
                        let encoded = try? JSONEncoder().encode(newValue)
                        foundCluesData = encoded ?? Data()
                    }
                ))
            }
            .navigationTitle("Brampton Scavenger Hunt")
            .toolbar {
                NavigationLink("My Rewards") {
                    PrizeView(foundCount: foundClues.count)
                }
            }
            .onAppear {
                // Load mock or API data
                clues = MockData.sampleClues
            }
        }
    }
}




