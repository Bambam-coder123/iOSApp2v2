//
//  ClueDetailView.swift
//  BramptonScavengerHunt
//
//  Created by Mac User on 2025-10-19.
//

import SwiftUI
import MapKit

struct ClueDetailView: View {
    var clue: Clue
    @Binding var foundClues: Set<String>
    @Binding var photoInfos: [CluePhotoInfo]

    @State private var selectedImage: UIImage?
    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FlippableCardView {
                    // FRONT of card
                    VStack {
                        Text(clue.name)
                            .font(.title.bold())
                        Text(clue.hint)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .background(Color.white)
                    .cornerRadius(16)
                } back: {
                    // BACK of card
                    VStack {
                        if let img = selectedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(12)
                                .shadow(radius: 4)
                        } else {
                            Text("Flip back and select a photo 👆")
                                .foregroundColor(.secondary)
                                .padding()
                        }

                        if !locationManager.currentAddress.isEmpty {
                            Text("📍 \(locationManager.currentAddress)")
                                .font(.footnote)
                                .padding(.top, 4)
                        }

                    }
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(16)
                }

                // Photo picker
                PhotoPickerView(selectedImage: $selectedImage)
                    .padding(.horizontal)

                // MARK: Mark Found Button
                Button(action: markAsFound) {
                    Label("Mark as Found", systemImage: "checkmark.seal.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedImage == nil ? Color.gray : Color.green)
                        .cornerRadius(12)
                }
                .disabled(selectedImage == nil)
                .padding(.horizontal)

                if foundClues.contains(clue.id) {
                    Text("✅ Found on this device")
                        .font(.footnote)
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
        .navigationTitle(clue.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func markAsFound() {
        guard let img = selectedImage else { return }

        // Save image to Documents directory
        let filename = "\(UUID().uuidString).jpg"
        if let data = img.jpegData(compressionQuality: 0.8) {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(filename)
            try? data.write(to: url)
        }

        // Build metadata
        let info = CluePhotoInfo(
            clueName: clue.name,
            fileName: filename,
            dateTaken: Date(),
            latitude: locationManager.currentLocation?.coordinate.latitude,
            longitude: locationManager.currentLocation?.coordinate.longitude,
            address: locationManager.currentAddress
        )

        photoInfos.append(info)
        savePhotoInfos()
        foundClues.insert(clue.id)
        dismiss()
    }

    private func savePhotoInfos() {
        if let data = try? JSONEncoder().encode(photoInfos) {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("PhotoInfos.json")
            try? data.write(to: url)
        }
    }
}
