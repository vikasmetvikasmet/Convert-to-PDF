//
//  CGSize+Extensions.swift
//  ConvectorInPDF
//
//  Created by Vika on 14.01.2025.
//

import SwiftUI

extension CGSize {
    func aspectFit(_ to: CGSize) -> CGSize {
        let scaleX = to.width / self.width
        let scaleY = to.height / self.height
        
        let aspectRation = min(scaleX, scaleY)
        return .init(width: aspectRation * width, height: aspectRation * height)
    }
}
