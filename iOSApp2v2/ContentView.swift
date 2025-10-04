//
//  ContentView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

//
//  ContentView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

import SwiftUI

struct ContentView: View {
    @State private var clues: [Clue] = []
    @State private var foundClues: Set<String> = []
    
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
                ClueDetailView(clue: clue, foundClues: $foundClues)
            }
            .navigationTitle("Brampton Scavenger Hunt")
            .toolbar {
                NavigationLink("My Rewards") {
                    PrizeView(foundCount: foundClues.count)
                }
            }
            .onAppear {
                // load fake data
                clues = MockData.sampleClues
            }
        }
    }
}



