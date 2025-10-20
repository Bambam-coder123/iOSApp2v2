//
//  ContentView.swift
//  iOSApp2v2
//
//  Created by Mac User on 2025-10-20.
//

import SwiftUI
import UIKit

/// NOTE:
/// This file intentionally DOES NOT declare a `struct Clue` so it won't conflict
/// with the Clue model already defined elsewhere in your project.

final class CluesViewModel: ObservableObject {
    @Published var clues: [Clue] = []
    @Published var loadingError: String?

    func loadClues() {
        // If you have an async ClueService, call it inside a Task.
        // If you load differently, replace this with your own loader.
        Task {
            do {
                if let serviceType = (NSClassFromString("ClueService") as? NSObject.Type) {
                    // try to call ClueService.shared.fetchClues() if available
                }
                // Attempt to call ClueService.shared.fetchClues() if the service exists in your project
                if let svc = (NSClassFromString("ClueService") as? NSObject.Type) {
                    // no-op: leaving a path for users who implement the service
                }

                // Try to call ClueService shared fetch with dynamic casting to avoid hard compile-time dependency here
                if let shared = (NSClassFromString("ClueService") as? NSObject.Type)?.value(forKey: "shared") as? AnyObject,
                   let fetch = shared.perform(NSSelectorFromString("fetchCluesWithCompletion:")) {
                    // If you have a legacy completion-based API named fetchCluesWithCompletion: handle it here.
                    // This branch is intentionally left as a placeholder. If your project uses `ClueService.shared.fetchClues()` async method,
                    // replace the whole loadClues implementation with the appropriate call below.
                }

                // --- Common: if you already have an async `ClueService.shared.fetchClues()` method returning [Clue] ---
                // Uncomment and use this if it exists in your project:
                //
                // let fetched = try await ClueService.shared.fetchClues()
                // await MainActor.run { self.clues = fetched }
                //
                // --- Fallback demo: leave clues empty if no service detected ---
                await MainActor.run {
                    // Leave clues empty by default. You can populate sample data here for previews if desired.
                    self.clues = []
                }
            } catch {
                await MainActor.run {
                    self.loadingError = error.localizedDescription
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = CluesViewModel()
    @State private var selectedClue: Clue? = nil
    @State private var showShareSheet = false
    @State private var shareItems: [Any] = []

    var body: some View {
        NavigationView {
            Group {
                if viewModel.clues.isEmpty {
                    VStack(spacing: 12) {
                        Text("No clues loaded")
                            .foregroundColor(.secondary)
                        Button("Reload") {
                            viewModel.loadClues()
                        }
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.clues) { clue in
                            Button(action: {
                                selectedClue = clue
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        // Use the fields your Clue model provides (location/hint assumed optional Strings)
                                        Text(clue.location ?? "Unknown location")
                                            .font(.headline)
                                        if let hint = clue.hint {
                                            Text(hint)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Clues")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Share selected clue") {
                            shareSelectedClue()
                        }
                        Button("Share all clues") {
                            shareAllClues()
                        }
                        Button("Reload") {
                            viewModel.loadClues()
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .onAppear {
                viewModel.loadClues()
            }
            .sheet(item: $selectedClue) { clue in
                // Present your ClueDetailView when a clue is tapped
                NavigationView {
                    ClueDetailView(clue: clue)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    selectedClue = clue
                                    shareSelectedClue()
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: shareItems)
            }
        }
    }

    // MARK: - Sharing helpers

    private func shareSelectedClue() {
        guard let clue = selectedClue else {
            // if no selected clue, just return
            return
        }
        let text = exportReport(for: clue)
        shareItems = [text]
        showShareSheet = true
    }

    private func shareAllClues() {
        let report = viewModel.clues.map { exportReport(for: $0) }.joined(separator: "\n\n---\n\n")
        shareItems = [report]
        showShareSheet = true
    }

    /// Produce a textual report for a single clue. You can expand this to attach images/files as needed.
    private func exportReport(for clue: Clue) -> String {
        var pieces: [String] = []
        pieces.append("Location: \(clue.location ?? "N/A")")
        pieces.append("Hint: \(clue.hint ?? "N/A")")
        if let urlString = (clue.imageURL ?? clue.imageUrl) as? String { // try both possible names
            pieces.append("Image: \(urlString)")
        } else if let urlString = clue.imageURL {
            pieces.append("Image: \(urlString)")
        }
        return pieces.joined(separator: "\n")
    }
}

// Simple ShareSheet wrapper for SwiftUI
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Preview - empty preview to avoid requiring `Clue` initializer; replace with real sample if you have one.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
