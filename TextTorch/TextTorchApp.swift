//
//  TextTorchApp.swift
//  TextTorch
//
//  Created by Liwen on 2025/3/24.
//

import SwiftUI
import SwiftData

@main
struct TextTorchApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: TextRecord.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HistoryView()
        }
        .modelContainer(container)
    }
}
