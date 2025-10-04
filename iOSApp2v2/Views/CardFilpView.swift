//
//  CardFilpView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

import SwiftUI

struct CardFlipView<Front: View, Back: View>: View {
    let front: Front
    let back: Back
    @State private var flipped = false
    
    init(@ViewBuilder front: () -> Front, @ViewBuilder back: () -> Back) {
        self.front = front()
        self.back = back()
    }
    
    var body: some View {
        ZStack {
            if flipped { back } else { front }
        }
        .onTapGesture { withAnimation { flipped.toggle() } }
    }
}


