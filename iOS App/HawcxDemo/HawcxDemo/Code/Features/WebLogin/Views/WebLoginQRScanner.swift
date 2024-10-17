//
//  WebLoginQRScanner.swift
//  demo
//
//  Created by Angel on 9/24/24.
//

import SwiftUI
import CodeScanner

struct WebLoginQRScanner: View {
    @StateObject var viewModel: WebLoginManualViewModel
    @ObservedObject var appState: AppState
    
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    
    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: WebLoginManualViewModel(appState: appState))
        self.appState = appState
    }

    var body: some View {
        VStack(spacing: 10) {
            

            Button("Scan Code") {
                isPresentingScanner = true
            }

            Text("Scan a QR code to begin")
        }
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.qr]) { response in
                if case let .success(result) = response {
                    viewModel.scannedCode = result.string
                    isPresentingScanner = false
                    viewModel.webLogin()
                } else {
                    isPresentingScanner = false
                    viewModel.qrScanFailed()
                }
            }
        }
    }
}

struct WebLoginQRScanner_Previews: PreviewProvider {
    static var previews: some View {
        WebLoginQRScanner(appState: AppState())
    }
}
