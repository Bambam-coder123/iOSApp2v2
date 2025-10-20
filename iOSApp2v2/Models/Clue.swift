//
//  Clue.swift
//  BramptonScavengerHunt
//

import Foundation

struct Clue: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let hint: String
    let location: String
    let imageUrl: String
}
