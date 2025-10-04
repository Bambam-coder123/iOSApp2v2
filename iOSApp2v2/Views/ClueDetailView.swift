//
//  ClueDetailView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

import SwiftUI
import PhotosUI

struct ClueDetailView: View {
    let clue: Clue
    @Binding var foundClues: Set<String>
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(clue.name)
                    .font(.largeTitle)
                    .bold()
                
                CardFlipView {
                    Text("Tap to Reveal Clue")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                } back: {
                    Text(clue.hint)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(12)
                }
                .padding(.vertical, 10)
                
                Text("Location: \(clue.location)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let imageUrl = clue.imageUrl,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Divider()
                
                Text("Upload Proof of Item")
                    .font(.headline)
                
                PhotoPickerView(selectedImage: $selectedImage)
                
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







