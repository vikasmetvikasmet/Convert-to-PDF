//
//  ConvectorView.swift
//  ConvectorInPDF
//
//  Created by Vika on 15.01.2025.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = 0
    @State private var scaneImageView: Bool = false
    @State var showScannerView: Bool = false
    var body: some View {
        NavigationView {
            
            TabView(selection: $selectedTab) {
                VStack(spacing: 20) {
                    
                    Button(action: {
                        showScannerView.toggle()
                        selectedTab = 1
                        
                        
                    }, label: {
                        Image("ScanYourFiles")
                            .resizable()
                            .frame(width: 180, height: 180)
                            .cornerRadius(35)
                    })
                    
                    Button(action: {
                        //
                    }, label: {
                        Image("ImageToPDF")
                            .resizable()
                            .frame(width: 180, height: 180)
                            .cornerRadius(35)
                    })
                    Button {
                        //
                    } label: {
                        Image("FileToPDF")
                            .resizable()
                            .frame(width: 180, height: 180)
                            .cornerRadius(35)
                    }
                    
                }
                
                .tabItem {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath.doc.on.clipboard")
                        Text("convector")
                    }
                    
                }.tag(0)
                ScanFilesView(showScannerView: $showScannerView)
                    .tabItem {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("files")
                        }
                    }.tag(1)
            }
            .navigationBarTitle(selectedTab == 0 ? "Convector in PDF" : "Files", displayMode: .large)
        }
    }
}

#Preview {
    MainView()
}
