//
//  PhotoPickerView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var selectedImage: UIImage?
    @State private var showingPicker = false
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            if let img = selectedImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 150)
                    .overlay(Text("Select Photo").foregroundColor(.gray))
            }
        }
        .onTapGesture {
            showingPicker = true
        }
        .photosPicker(isPresented: $showingPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
    }
}

