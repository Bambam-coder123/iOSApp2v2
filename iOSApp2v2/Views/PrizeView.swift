//
//  PrizeView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-02.
//

import SwiftUI

struct PrizeView: View {
    let foundCount: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("My Rewards")
                .font(.largeTitle)
                .bold()
            
            Text("Clues Found: \(foundCount)")
                .font(.title2)
            
            if foundCount > 0 {
                Text("🎉 Keep going to unlock more rewards!")
            } else {
                Text("Start finding clues to earn rewards!")
            }
            
            Spacer()
        }
        .padding()
    }
}



