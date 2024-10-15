//
//  SignUpView.swift
//  demo
//
//  Created by dev on 9/30/24.
//

//
//  SignupView.swift
//  demo
//
//  Created by Angel on 8/29/24.
//

import SwiftUI
import AlertToast

struct SignUpView: View {
    @StateObject var viewModel: SignUpViewModel
    
    
    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: SignUpViewModel(appState: appState))
    }
    
    
    var body: some View {
        ZStack {
            
            VStack {
                
                VStack {
                    HStack {
                        
                        Spacer()
                        
                        Text("Signup")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 12)
                        
                        Spacer()
                        
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
                        
                        if viewModel.isSignupVisible {
                            
                            Image("logo")
                                .resizable()
                                .frame(width: 320, height: 300)
                                .padding(.top)
                            
                            VStack(spacing: 10) {
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
                                
                                
                                Button(action: {
                                    viewModel.handleSignUp()                      }) {
                                        //
                                        HStack {
                                            Image(systemName: "lock.fill")
                                                .foregroundColor(.white)
                                            Text("Signup")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                        }.frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                    .padding(.horizontal)
                                
                                Spacer()
                                
                                Text("Login")
                                    .font(.title2)
                                    .underline()
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 20)
                                    .onTapGesture {
                                        // Navigate to login view
                                        viewModel.appState.showView(ScreenView.login)
                                    }
                                    .padding(.top, 30)
                                
                                Text("Reset Device")
                                    .font(.title2)
                                    .underline()
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 20)
                                    .onTapGesture {
                                        // Navigate to login view
                                        viewModel.appState.showView(ScreenView.reset)
                                    }
                                    .padding(.top, 0)
                                
                            }
                            .padding(.top)
                            .padding(.horizontal)
                            
                            Spacer()
                        }
                        
                        if viewModel.isOtpVisible {
                            
                            Spacer()
                                .frame(height: 50)
                            VStack(spacing: 10) {
                                
                                Text("Enter the 6-digit Code")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                
                                VStack {
                                    HStack {
                                        (Text("Check ") + Text(viewModel.email).bold() + Text(" for a verification code."))
                                            .padding()
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Button(action: {
                                            viewModel.handleAnotherAccount()
                                        }) {
                                            Text("Change")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                                
                                HStack(alignment: .top) {
                                    TextField("Enter OTP", text: $viewModel.otp)
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(.top, 30)
                                
                                Button(action: {
                                    viewModel.handleResend()
                                }) {
                                    Text("Resend code")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.blue)
                                }
                                
                                Button(action: {
                                    // Resend Code action
                                    viewModel.handleVerifyOTP()
                                }) {
                                    Text("Submit")
                                        .frame(maxWidth: .infinity, minHeight: 60)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .padding(.top, 30)
                                }
                                
                                
                                
                            }
                            .padding(.top)
                            .padding(.horizontal, 30)
                            
                        }
                    }
                    
                    
                }
                
                
            }.toast(isPresenting: $viewModel.appState.showToast, duration: 2, tapToDismiss: true) {
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
    
    struct SignupView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpView(appState: AppState())
        }
    }
}
