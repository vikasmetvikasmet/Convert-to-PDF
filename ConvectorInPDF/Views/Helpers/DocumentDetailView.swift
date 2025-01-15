//
//  DocumentDetailView.swift
//  ConvectorInPDF
//
//  Created by Vika on 14.01.2025.
//

import SwiftUI
import PDFKit

struct DocumentDetailView: View {
    @State var document: Document
    @State private var currentPageIndex: Int = 0
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
        if let pages = document.pages?.sorted(by: { $0.pageIndex < $1.pageIndex}) {
            VStack(spacing: 10) {
                TabView(selection: $currentPageIndex) {
                    ForEach(pages.indices, id: \.self) {index in
                        let page = pages[index]
                        if let image = UIImage(data: page.pageData) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tag(index)
                        }
                        
                    }
                }
                .tabViewStyle(.page)
                FooterView {
                    deletePage(at: currentPageIndex)
                }
            }
            .background(.black)
        }
    }
    
    @ViewBuilder
    private func FooterView(deleteAction: @escaping () -> Void) -> some View {
        HStack {
            Spacer()
            Button(action: deleteAction) {
                Image(systemName: "trash.fill")
                    .font(.title3)
                    .foregroundStyle(.red)
            }
        }
        .padding([.horizontal, .bottom], 15)
    }
    private func deletePage(at index: Int) {
        guard let _ = document.pages else { return }
        
        document.pages?.remove(at: index)
        
        if index == currentPageIndex {
            currentPageIndex = max(0, index - 1 )
        }
        if document.pages?.isEmpty == true  {
            dismiss()
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.3))
                context.delete(document)
            }
        }
    }
}

