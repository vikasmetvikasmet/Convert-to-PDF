//
//  View+Extensions.swift
//  ConvectorInPDF
//
//  Created by Vika on 14.01.2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hSpacing(_ aligment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: aligment)
    }
    
    @ViewBuilder
    func vSpacing(_ aligment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: aligment)
    }
    
    @ViewBuilder
    func loadingScreen(status: Binding<Bool>) -> some View {
        self
            .overlay {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .frame(width: 40, height: 40)
                        .background(.bar, in: .rect(cornerRadius: 10))
                }
                .opacity(status.wrappedValue ? 1: 0)
                .allowsHitTesting(status.wrappedValue)
                .animation(snappy, value: status.wrappedValue)
            }
    }
    
    var snappy: Animation {
        .snappy(duration: 0.25, extraBounce: 0)
    }
}
