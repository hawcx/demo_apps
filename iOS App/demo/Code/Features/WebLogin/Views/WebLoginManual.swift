//
//  WebLoginManual.swift
//  demo
//
//  Created by Angel on 9/23/24.
//

import SwiftUI
import AlertToast

struct WebLoginManual: View {
    @StateObject var viewModel: WebLoginManualViewModel
    @ObservedObject var appState: AppState
    
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
            
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    Spinner()
                }.frame(maxHeight: .infinity)
            }
            
            ScrollView{
                if !viewModel.isLoading {
                    Spacer().frame(height: 100)
                    VStack(spacing: 40) {
                        // QR Code Input Field
                        TextField("Enter the QR Code", text: $viewModel.qrCodeText)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                            .textFieldStyle(PlainTextFieldStyle()) // To make the text look like an EditText field
                        
                        // Login Button
                        Button(action: {
                            // Action for login button
                            viewModel.handleLogin()
                        }) {
                            Text("Login")
                                .frame(width: UIScreen.main.bounds.width * 0.85, height: 54)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Information")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.blue)
                            
                            Text("* The code will be shown in the Hawcx website")
                                .font(.system(size: 16))
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.top, 20)
                    }
                    .padding(.top, 40) // Equivalent to layout_marginTop="40dp"
                    
                    Spacer()
                } 
            }
            
        }
        .frame(maxWidth: .infinity)
        .toast(isPresenting: $viewModel.appState.showToast, duration: 2, tapToDismiss: true) {
            switch viewModel.appState.alertType {
            case .success:
                AlertToast(displayMode:.banner(.pop), type: .complete(.green),  title: viewModel.appState.alertTitle, style: viewModel.appState.successStyle)
            case .error:
                AlertToast(displayMode:.banner(.pop), type: .error(.red),  title: viewModel.appState.alertTitle, style: viewModel.appState.errorStyle)
            default:
                AlertToast(displayMode:.banner(.pop), type: .error(.red),  title: viewModel.appState.alertTitle, style: viewModel.appState.errorStyle)
            }
        }
    }
}

struct WebLoginManual_Previews: PreviewProvider {
    static var previews: some View {
        WebLoginManual(appState: AppState())
    }
}
