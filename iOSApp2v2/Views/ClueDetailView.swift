//
//  ClueDetailView.swift
//  BramptonScavengerHunt
//
//  Created by Mac User on 2025-10-02.
//

import SwiftUI
import PhotosUI

struct ClueDetailView: View {
    let clue: Clue
    @Binding var foundClues: Set<String>
    @State private var selectedImage: UIImage?
    
    // Mock "next clues" for demo — replace with actual logic
    let nextClues: [Clue] = MockData.sampleClues.shuffled()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(clue.name ?? "Unknown Clue")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                // MARK: Flippable Card
                if let selectedImage = selectedImage {
                    FlippableCardView {
                        // FRONT — photo proof
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .cornerRadius(12)
                            .overlay(
                                Text("Tap to Flip")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(8)
                                    .padding(),
                                alignment: .bottomTrailing
                            )
                    } back: {
                        // BACK — next clues list
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Next Clues:")
                                .font(.title3)
                                .bold()
                            ForEach(nextClues.prefix(3), id: \.id) { clue in
                                Text("🔍 \(clue.name ?? "Unnamed Clue")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 250)
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(12)
                    }
                } else {
                    // Before photo is selected
                    Text("Select a photo to reveal your flippable clue card!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Divider()
                
                // MARK: Photo Picker
                Text("Upload Proof of Item")
                    .font(.headline)
                
                PhotoPickerView(selectedImage: $selectedImage)
                
                // MARK: Mark as Found
                if selectedImage != nil {
                    Button("Mark as Found") {
                        foundClues.insert(clue.id)
                    }
                    .buttonStyle(.borderedProminent)
                }

            }
            .padding()
        }
        .navigationTitle(clue.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}








