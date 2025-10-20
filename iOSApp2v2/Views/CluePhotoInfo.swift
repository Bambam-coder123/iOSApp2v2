//
//  CluePhotoInfo.swift
//  BramptonScavengerHunt
//
//  Created by Mac User on 2025-10-19.
//

import Foundation
import CoreLocation

struct CluePhotoInfo: Codable, Identifiable {
    var id = UUID()
    var clueName: String
    var fileName: String
    var dateTaken: Date
    var latitude: Double?
    var longitude: Double?
    var address: String?
}
