//
//  WelcomeScreen.swift
//  ConvectorInPDF
//
//  Created by Vika on 14.01.2025.
//

import SwiftUI

struct WelcomeScreen: View {
    @AppStorage("showIntroView") private var showIntroView: Bool = true
    var body: some View {
        VStack(spacing: 15) {
            Text("Welcome \nto PDF Convert")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            VStack(alignment: .leading, spacing: 25) {
                PointView(
                    title: "Convert to PDF",
                    image: "scanner",
                    description: "Convert any document with ease."
                )
                PointView(
                    title: "Save Documents",
                    image: "tray.full.fill",
                    description: "Persist scanned documents with the new SwiftData Model."
                )
                PointView(
                    title: "Share Document",
                    image: "square.and.arrow.up",
                    description: "Share new documents through any available method."
                )
            }
            .padding(.horizontal, 25)
            
            Spacer(minLength: 0)
            
            Button {
                showIntroView = false
                
            } label: {
                Text("Convert to PDF file")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(Color("ColorScan").gradient, in: .capsule)
                
            }

        }
        .padding(15)
    }
    
    @ViewBuilder
    private func PointView(title: String, image: String, description: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: image)
                .font(.largeTitle)
                .foregroundStyle(Color("ColorScan"))
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}
