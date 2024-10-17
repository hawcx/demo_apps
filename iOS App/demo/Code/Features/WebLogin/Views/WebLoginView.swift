//
//  WebLoginView.swift
//  demo
//
//  Created by Angel on 9/23/24.
//

import SwiftUI
import CodeScanner

struct WebLoginView: View {
    @StateObject var viewModel: WebLoginManualViewModel
    @ObservedObject var appState: AppState
    
    @State private var isPresentingScanner = false
    
    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: WebLoginManualViewModel(appState: appState))
        self.appState = appState
    }
    
    var body: some View {
        
        VStack {
            
            VStack {
                HStack {
                    
                    Button(action: {
                        appState.showView(ScreenView.homeDeviceList)
                    }) {
                        Label("home", systemImage: "arrow.left")
                    }
                    
                    Text("Web Login")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 12)
                    
                    Spacer()
                        .frame(width: 60)
                    
                }
                .foregroundColor(.black)
                
                
                Divider()
                    .background(Color.black)
            }
            .frame(maxWidth: .infinity)
            
            ScrollView{
                VStack {
                    
                    Spacer().frame(height: 50)
                    
                    // Header
                    Text("Scan / Enter the Code")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.0, green: 160/255, blue: 1.0))
                        .multilineTextAlignment(.center)
                    
                    // Subheader
                    Text("Code shown in your web to connect")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 128/255, green: 195/255, blue: 1.0))
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    
                    Spacer().frame(height: 50)
                    
                    // QR Code Button
                    Button(action: {
                        // Add QR Scan action here
                        isPresentingScanner = true
                    }) {
                        
                        HStack {
                            Image(systemName: "qrcode")
                                .foregroundColor(.white)
                            Text("Scan QR")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }.frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 24)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    
                    // Manual Button
                    Button(action: {
                        // Add Manual action here
                        appState.showView(ScreenView.webLoginManual)
                    }) {
                        HStack {
                            Image(systemName: "keyboard")
                                .foregroundColor(.white)
                            Text("Manual")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }.frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 30)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .padding(.top, 50)
                .sheet(isPresented: $isPresentingScanner) {
                    ZStack{
                        
                        CodeScannerView(codeTypes: [.qr], completion: { response in
                            if case let .success(result) = response {
                                viewModel.scannedCode = result.string
                                isPresentingScanner = false
                                viewModel.webLogin()
                            } else {
                                isPresentingScanner = false
                                viewModel.qrScanFailed()
                            }
                        })
                        
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red, lineWidth: 4)
                            .frame(width: 300, height: 300)
                        
                        VStack {
                            HStack {
                                Button(action: {
                                    // Dismiss the scanner or perform your back action
                                    isPresentingScanner = false
                                }) {
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                Spacer() // Pushes the button to the left
                            }
                            Spacer() // Pushes the button to the top
                        }
                        .padding() // Adds padding around the button
                    }
                }
            }
        }
    }
    
    struct WebLoginView_Previews: PreviewProvider {
        static var previews: some View {
            WebLoginView(appState: AppState())
        }
    }
}
