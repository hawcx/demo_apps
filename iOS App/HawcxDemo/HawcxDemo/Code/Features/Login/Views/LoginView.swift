//
//  LoginView.swift
//  demo
//
//  Created by Angel on 8/28/24.
//

import SwiftUI
import AlertToast


struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(appState: appState))
    }
    
    
    
    var body: some View {
        ZStack {
            
            VStack {

                // Appbar
                VStack {
                    HStack {
                        
                        Button(action: {
                            viewModel.appState.showView(ScreenView.signup)
                        }) {
                            Label("signup", systemImage: "arrow.left")
                        }
                        
                        Text("Login")
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
                
                ScrollView {
                    VStack {
                        
                        
                        if viewModel.isLoginVisible {
                            Image("logo")
                                .resizable()
                                .frame(width: 320, height: 300)
                                .padding(.top)
                            
                            VStack(spacing: 10) {
                                if viewModel.appState.isFirstLogin {
                                    HStack(alignment: .top) {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                        TextField("example.com", text: $viewModel.email)
                                    }
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .padding()
                                    .padding(.top, 30)
                                    
                                    HStack {
                                        Button(action: {
                                            viewModel.handleLogin()                       }) {
                                                HStack {
                                                    Image(systemName: "lock.fill")
                                                        .foregroundColor(.white)
                                                    Text("Login")
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.white)
                                                }.frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.blue)
                                                    .cornerRadius(10)
                                            }
                                            .padding(.horizontal)
                                        
                                    }
                                }
                                
                                if !viewModel.appState.isFirstLogin {

                                    if !viewModel.isBiometrics {
                                        HStack(alignment: .top) {
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                            TextField("example.com", text: $viewModel.email)
                                        }
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .padding()
                                        .padding(.top, 30)
                                        
                                        HStack {
                                            Button(action: {
                                                viewModel.handleLogin()                       }) {
                                                    HStack {
                                                        Image(systemName: "lock.fill")
                                                            .foregroundColor(.white)
                                                        Text("Login")
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(.white)
                                                    }.frame(maxWidth: .infinity)
                                                        .padding()
                                                        .background(Color.blue)
                                                        .cornerRadius(10)
                                                }
                                                .padding(.horizontal)
                                            
                                        }

                                        Text("Use Biometrics")
                                            .font(.title2)
                                            .underline()
                                            .foregroundColor(.gray)
                                            .padding(.top, 30)
                                            .onTapGesture {
                                                // Navigate to login view
                                                viewModel.isBiometrics.toggle()
                                            }
                                    }

                                    else {

                                        Text("Login with your faceID or touchID")
                                            .font(.title)
                                            .foregroundColor(.black)
                                            .padding(.bottom, 20)

                                        Button(action: {
                                            viewModel.biometrics()
                                        }) {
                                            Label("", systemImage: "touchid")
                                                .font(.system(size: 50))
                                        }

                                        Text("Login with username")
                                            .font(.title2)
                                            .underline()
                                            .foregroundColor(.gray)
                                            .padding(.top, 30)
                                            .onTapGesture {
                                                // Navigate to login view
                                                viewModel.isBiometrics.toggle()
                                            }
                                    }
                                }
                        
                                
                                Spacer()
                                
                              
                                
                                Text("Sign Up")
                                    .font(.title2)
                                    .underline()
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 20)
                                    .onTapGesture {
                                        // Navigate to login view
                                        viewModel.appState.showView(ScreenView.signup)
                                    }
                            }
                            .padding(.top)
                            .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear(perform: viewModel.authenticate)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(appState: AppState())
    }
}
