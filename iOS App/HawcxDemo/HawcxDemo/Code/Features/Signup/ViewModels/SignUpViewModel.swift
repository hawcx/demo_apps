//
//  SignUpViewModel.swift
//  demo
//
//  Created by Angel on 9/4/24.
//

import Foundation
import HawcxFramework

class SignUpViewModel: ObservableObject, SignUpCallback {
    @Published var email: String = ""
    @Published var otp: String = ""
    @Published var isOtpVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var isSignupVisible: Bool = true
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var toastType: AlertType? = nil

    var appState: AppState
    
    private var signUpManager: SignUp
    
    init(appState: AppState) {
        self.signUpManager = SignUp(apiKey: CONSTANTS.apiKey)
        self.appState = appState
        self.appState.showToast = false
    }
    
//    SignUp button clicked
    func handleSignUp() {
        signUp()
    }
//    Verify OTP button clicked
    func handleVerifyOTP() {
        verifyOTP()
    }
//    resend button clicked
    func handleResend() {
        otp = ""
        signUp()
    }
//    another account button clicked
    func handleAnotherAccount() {
        email = ""
        signUpVisible()
    }
    
    private func signUp() {
        if isValidEmail(email) {
            loading()
//            signUpManager.handleAddUser(userid: email, callback: self)
            signUpManager.signUp(userid: email, callback: self)
        } else {
            showToast = true
            appState.showToast("Enter a valid email address", AlertType.error, true)
        }
    }
    
    private func verifyOTP() {
        if isValidOTP(otp) {
            loading()
            signUpManager.handleVerifyOTP(userid: email, otp: otp, callback: self)
        } else {
            appState.showToast("Enter a valid OTP", AlertType.error, true)
        }
    }
    
    private func loading() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.isOtpVisible = false
            self.isSignupVisible = false
        }
    }
    
    private func signUpVisible() {
        DispatchQueue.main.async {
            self.isSignupVisible = true
            self.isLoading = false
            self.isOtpVisible = false
        }
    }
    
    private func otpVisible() {
        DispatchQueue.main.async {
            self.isOtpVisible = true
            self.isLoading = false
            self.isSignupVisible = false
        }
    }
    
    // SignUpCallback methods
    func showError(signUpErrorCode: SignUpErrorCode, errorMessage: String) {
        
        DispatchQueue.main.async {
            self.appState.showToast(errorMessage, AlertType.error, true)

            
            // Delay for user to see the error message before any navigation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                switch signUpErrorCode {
                case .userAlreadyExists:
                    self.appState.showView(ScreenView.login)
                case .verifyOtpFailed:
                    self.otpVisible()
                default:
                    self.signUpVisible()
                }
            }
        }
    }
    
    func onSuccessfulSignUp() {
        
        DispatchQueue.main.async {
            self.appState.showToast("SignUp successful", AlertType.success, true)
            
            // Delay the navigation to allow the toast to be visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust the duration as needed
                self.appState.showView(ScreenView.login)
                self.signUpVisible()
            }
        }
    }
    
    func onGenerateOTPSuccess() {
        toastMessage = "OTP generated successful"
        appState.showToast(toastMessage, AlertType.success, true)
        
        otpVisible()
        
    }
}
