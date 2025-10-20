//
//  LocationManager.swift
//  BramptonScavengerHunt
//
//  Created by Mac User on 2025-10-19.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation?
    @Published var currentAddress: String = ""
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        currentLocation = loc
        fetchAddress(for: loc)
    }

    private func fetchAddress(for location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            if let place = placemarks?.first {
                self?.currentAddress = [place.name, place.locality, place.administrativeArea]
                    .compactMap { $0 }
                    .joined(separator: ", ")
            }
        }
    }
}
