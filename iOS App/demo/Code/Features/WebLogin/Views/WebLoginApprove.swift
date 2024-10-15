//
//  WebLoginApprove.swift
//  demo
//
//  Created by Angel on 9/23/24.
//

import SwiftUI
import AlertToast

struct WebLoginApprove: View {
    
    @StateObject var viewModel: WebLoginApproveViewModel
    @ObservedObject var appState: AppState
    
    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: WebLoginApproveViewModel(appState: appState))
        self.appState = appState
    }
    
    var body: some View {
        ZStack {
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
                    VStack(spacing: 20) {
                        
                        
                        // Details container
                        if !viewModel.isLoading {
                            
                            // Title
                            Text("New Login Attempt")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "#3498db"))
                            
                            // Description
                            Text("A device is attempting to log in to your account.")
                                .font(.body)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(viewModel.deviceText)
                                    .font(.body)
                                    .foregroundColor(Color(hex: "#555555"))
                                
                                Text(viewModel.osText)
                                    .font(.body)
                                    .foregroundColor(Color(hex: "#555555"))
                                
                                Text(viewModel.browserText)
                                    .font(.body)
                                    .foregroundColor(Color(hex: "#555555"))
                                
                                Text(viewModel.locationText)
                                    .font(.body)
                                    .foregroundColor(Color(hex: "#555555"))
                                
                                Text(viewModel.timeText)
                                    .font(.body)
                                    .foregroundColor(Color(hex: "#555555"))
                            }
                            .padding(.top, 20)
                            
                            // Action buttons
                            HStack(spacing: 20) {
                                Button(action: {
                                    // Reject action
                                    viewModel.handleReject()
                                }) {
                                    Text("Reject")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .foregroundColor(Color(hex: "#3498db"))
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color(hex: "#3498db"), lineWidth: 1)
                                        )
                                }
                                
                                Button(action: {
                                    // Approve action
                                    viewModel.handleApprove()
                                }) {
                                    Text("Approve")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color(hex: "#3498db"))
                                        .cornerRadius(5)
                                }
                            }
                            .padding(.top, 20)
                            
                            Spacer()
                        }
                    }
                    .padding(60)
                    
                    
                }
                
            }
            
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
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

struct WebLoginApprove_Previews: PreviewProvider {
    static var previews: some View {
        WebLoginApprove(appState: AppState())
    }
}
