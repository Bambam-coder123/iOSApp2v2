//
//  PDFReportManager.swift
//  BramptonScavengerHunt
//
//  Created by Mac User on 2025-10-19.
//

import Foundation
import PDFKit
import SwiftUI
import MapKit

class PDFReportManager {
    static func generateReport(from photos: [CluePhotoInfo]) -> URL? {
        let pdf = PDFDocument()
        for (index, photo) in photos.enumerated() {
            let page = PDFPage(image: renderPage(for: photo))
            pdf.insert(page!, at: index)
        }

        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("HuntReport.pdf")
        pdf.write(to: fileURL)
        return fileURL
    }

    private static func renderPage(for photo: CluePhotoInfo) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 612, height: 792)) // A4
        return renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 612, height: 792))

            // Title
            let title = "Clue Found: \(photo.clueName)"
            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 22)
            ]
            title.draw(at: CGPoint(x: 40, y: 40), withAttributes: titleAttrs)

            // Address & Date
            let info = """
            Date: \(photo.dateTaken.formatted())
            Location: \(photo.address ?? "Unknown")
            """
            info.draw(at: CGPoint(x: 40, y: 80), withAttributes: [.font: UIFont.systemFont(ofSize: 16)])

            // Snapshot map if possible
            if let lat = photo.latitude, let lon = photo.longitude {
                let mapSnapshot = generateMapSnapshot(latitude: lat, longitude: lon)
                mapSnapshot?.draw(in: CGRect(x: 40, y: 130, width: 250, height: 250))
            }

            // Photo proof
            if let image = loadSavedImage(named: photo.fileName) {
                image.draw(in: CGRect(x: 320, y: 130, width: 250, height: 250))
            }
        }
    }

    private static func generateMapSnapshot(latitude: Double, longitude: Double) -> UIImage? {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        options.size = CGSize(width: 250, height: 250)

        let snapshotter = MKMapSnapshotter(options: options)
        var image: UIImage?
        let semaphore = DispatchSemaphore(value: 0)
        snapshotter.start { snapshot, _ in
            image = snapshot?.image
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 2)
        return image
    }

    private static func loadSavedImage(named fileName: String) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }
}
