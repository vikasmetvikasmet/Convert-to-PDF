//
//  DocumentCardView.swift
//  ConvectorInPDF
//
//  Created by Vika on 14.01.2025.
//

import SwiftUI
import PDFKit

struct DocumentCardView: View {
    @State private var isLoading: Bool = false
    @State private var showFileMover: Bool = false
    @State private var fileURL: URL?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var document: Document
    @State private var downsizedImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let firstPage = document.pages?.sorted(by: { $0.pageIndex < $1.pageIndex }).first {
                
                GeometryReader {
                    let size = $0.size
                    
                    if let downsizedImage {
                        Image(uiImage: downsizedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                    } else {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .task(priority: .high) {
                                guard let image = UIImage(data: firstPage.pageData) else {return}
                                let aspectSize = image.size.aspectFit(.init(width: 150, height: 150))
                                let render = UIGraphicsImageRenderer(size: aspectSize)
                                let resizedImage = render.image { context in
                                    image.draw(in: .init(origin: .zero, size: aspectSize))
                                }
                                await MainActor.run {
                                    downsizedImage = resizedImage
                                }
                            }
                    }
                }
                .frame(height: 150)
                .clipShape(.rect(cornerRadius: 15))
            }
            Text(document.name)
                .font(.callout)
                .lineLimit(1)
                .padding(.top, 10)
            
            Text(document.createdAt.formatted(date: .numeric, time: .omitted))
                .font(.caption2)
                .foregroundStyle(.gray)
        }.contextMenu {
            Button(action: createAndShareDocument) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            Button(role: .destructive) {
                dismiss()
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(0.3))
                    context.delete(document)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button {
                print("Merge")
            } label: {
                Label("Merge", systemImage: "doc.on.doc")
            }
            
        }
        .loadingScreen(status: $isLoading)
        .fileMover(isPresented: $showFileMover, file: fileURL) { result in
            if case .failure(_) = result {
                guard let fileURL else { return}
                try? FileManager.default.removeItem(at: fileURL)
                self.fileURL = nil
            }
        }
        
    }
    private func createAndShareDocument() {
        guard let pages = document.pages?.sorted(by: { $0.pageIndex < $1.pageIndex}) else {return}
        isLoading = true
        Task.detached(priority: .high) { [document] in
            try? await Task.sleep(for: .seconds(0.2))
            let pdfDocument = PDFDocument()
            for index in pages.indices {
                if let pageImage = UIImage(data: pages[index].pageData),
                   let pdfPage = PDFPage(image: pageImage) {
                    pdfDocument.insert(pdfPage, at: index)
                }
            }
            var pdfURL = FileManager.default.temporaryDirectory
            let fileName = "\(document.name).pdf"
            pdfURL.append(path: fileName)
            
            if pdfDocument.write(to: pdfURL) {
                await MainActor.run { [pdfURL] in
                    fileURL = pdfURL
                    showFileMover = true
                    isLoading = false
                }
            }
        }
    }
}
