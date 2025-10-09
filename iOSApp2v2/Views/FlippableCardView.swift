//
//  FlippableCardView.swift
//  BramptonScavengerHunt
//
//  Created by Mac User on 2025-10-02.
//

import SwiftUI

struct FlippableCardView<Front: View, Back: View>: View {
    @State private var flipped = false
    var front: () -> Front
    var back: () -> Back
    
    var body: some View {
        ZStack {
            front()
                .opacity(flipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(flipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
            
            back()
                .opacity(flipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(flipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .animation(.spring(), value: flipped)
        .onTapGesture {
            withAnimation {
                flipped.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding()
    }
}
