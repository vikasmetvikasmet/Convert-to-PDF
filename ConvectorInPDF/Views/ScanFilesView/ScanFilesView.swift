//
//  Home.swift
//  ConvectorInPDF
//
//  Created by Vika on 14.01.2025.
//

import SwiftUI
import SwiftData
import VisionKit

struct ScanFilesView: View {
    @Binding var showScannerView: Bool
    @State private var scanDocument: VNDocumentCameraScan?
    @State private var documentName: String = "New Document"
    @State private var askDocumentName: Bool = false
    @State private var isLoading: Bool = false
    @Query(sort: [.init( \Document.createdAt, order: .reverse)], animation: .snappy(duration: 0.25, extraBounce: 0)) private var documents: [Document]
    
    @Namespace private var animationID
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 15) {
                    ForEach(documents) { document in
                        NavigationLink {
                            DocumentDetailView(document: document)
                        } label: {
                            DocumentCardView(document: document)
                                .foregroundStyle(Color.primary)
                        }

                    }
                }
                .padding(15)
                
            }

        }.fullScreenCover(isPresented: $showScannerView) {
            ScannerModel { error in
                
            } didCancel: {
                showScannerView = false
                
            } didFinish: { scan in
                scanDocument = scan
                showScannerView = false
                askDocumentName = true
                
            }
            .ignoresSafeArea()

        }
        .alert("Document Name", isPresented: $askDocumentName) {
            TextField("New Document", text: $documentName)
            
            Button("Save") {
                createDocument()
            }
            .disabled(documentName.isEmpty)
        }
        .loadingScreen(status: $isLoading)
    }
    
    private func createDocument() {
        guard let scanDocument else {return}
        isLoading = true
        Task.detached(priority: .high) { [documentName] in
            let document = Document(name: documentName)
            var pages: [DocumentPage] = []
            
            for pageIndex in 0 ..< scanDocument.pageCount {
                let pageImage = scanDocument.imageOfPage(at: pageIndex)
                guard let pageData = pageImage.jpegData(compressionQuality: 0.65) else {return}
                let documentPage = DocumentPage(document: document, pageIndex: pageIndex, pageData: pageData)
                pages.append(documentPage)
            }
            document.pages = pages
      
            await MainActor.run {
                context.insert(document)
                try? context.save()
                self.scanDocument = nil
                isLoading = false
                self.documentName = "New Document"
            }
        }
        
    }
}

#Preview {
    ContentView()
}
