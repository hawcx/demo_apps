//
//  ResetViewModel.swift
//  demo
//
//  Created by Angel on 9/20/24.
//

import Foundation

class ResetViewModel: ObservableObject, RestoreCallback {
    @Published var email: String = ""
    @Published var otp: String = ""
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
    @Published var isOtpVisible: Bool = false
    @Published var isRestoreVisible: Bool = true
    
    @Published var toastMessage: String = ""
    @Published var showToast: Bool = false
    
    var appState: AppState
    
    var restoreManager: Restore
    
    init(appState: AppState) {
        let apiKey = CONSTANTS.apiKey
        self.restoreManager = Restore(apiKey: apiKey)
        self.appState = appState
        self.appState.showToast = false
    }
    
    private func loading() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.isRestoreVisible = false
            self.isOtpVisible = false
        }
    }
    
    private func restoreVisible() {
        DispatchQueue.main.async {
            self.isRestoreVisible = true
            self.isLoading = false
            self.isOtpVisible = false
        }
    }
    
    private func otpVisible() {
        DispatchQueue.main.async {
            self.isOtpVisible = true
            self.isLoading = false
            self.isRestoreVisible = false
        }
    }
    
    func handleAnotherAccount() {
        email = ""
        restoreVisible()
    }
    
    func handleResend() {
        otp = ""
        restore()
    }
    
    public func restore() {
        if isValidEmail(email) {
            loading()
            restoreManager.restore(userid: email, callback: self)
        } else {
            toastMessage = "Input email valid"
            appState.showToast(toastMessage, AlertType.error, true)
        }
    }
    
    public func handleVerifyOTP() {
        if isValidOTP(otp) {
            loading()
            restoreManager.handleVerifyOTP(userid: email, otp: otp, callback: self)
        } else {
            appState.showToast("Enter a valid OTP", AlertType.error, true)
        }
    }
    
    func showError(restoreErrorCode: RestoreErrorCode, errorMessage: String) {
        DispatchQueue.main.async {
            self.appState.showToast(errorMessage, AlertType.error, true)
            
            // Delay for user to see the error message before any navigation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                switch restoreErrorCode {
                case .userAlreadyExists:
                    self.appState.showView(ScreenView.login)
                case .generateOtpFailed, .verifyOtpFailed:
                    self.otpVisible()
                default:
                    self.restoreVisible()
                }
            }
        }
    }
    
    func onSuccessfulRestore() {
        //        navigate to Login
        
        DispatchQueue.main.async {
            self.appState.showToast("Restore device successful", AlertType.success, true)
            
            // Delay the navigation to allow the toast to be visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust the duration as needed
                self.appState.showView(ScreenView.login)
                self.restoreVisible()
            }
        }
    }
    
    func onGenerateOTPSuccess() {
        toastMessage = "OTP generated successful"
        appState.showToast(toastMessage, AlertType.success, true)
        
        otpVisible()
    }
}
