//
//  ConvectorInPDFApp.swift
//  ConvectorInPDF
//
//  Created by Vika on 13.01.2025.
//

import SwiftUI

@main
struct ConvectorInPDFApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Document.self)
        }
    }
}
