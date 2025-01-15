//
//  ContentView.swift
//  ConvectorInPDF
//
//  Created by Vika on 13.01.2025.
//

import SwiftUI
import PDFKit
import PhotosUI

struct ContentView: View {
    @AppStorage("showIntroView") private var showIntroView: Bool = true
    var body: some View {
        MainView()
            .sheet(isPresented: $showIntroView) {
                WelcomeScreen()
                    .interactiveDismissDisabled()
            }
    }
}
#Preview {
    
        ContentView()
    
}
