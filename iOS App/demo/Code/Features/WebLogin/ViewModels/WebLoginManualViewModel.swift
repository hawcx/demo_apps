//
//  WebLoginManualViewModel.swift
//  demo
//
//  Created by Angel on 9/24/24.
//

import Foundation

class WebLoginManualViewModel: ObservableObject, WebLoginCallback {
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var qrCodeText: String = ""
    @Published var isLoading: Bool = false
    @Published var scannedCode: String = ""
    
    var appState: AppState
    
    private var webLoginManager: WebLoginManager
    
    init(appState: AppState) {
        self.webLoginManager = WebLoginManager(apiKey: CONSTANTS.apiKey)
        self.appState = appState
        self.appState.showToast = false
    }
    
//    Login button clicked
    func handleLogin() {
        webLoginManual()
    }
    
    
    private func webLoginManual() {
        if isValidPin(qrCodeText) {
            loading(true)
            if let accessToken = UserDefaults.standard.string(forKey: "access_token") {
                webLoginManager.webLogin(accessToken: accessToken, pin: qrCodeText, callback: self)
            } else {
                appState.showView(ScreenView.login)
            }
        } else {
            appState.showToast("Enter a valid web pin", AlertType.error, true)
        }
    }
    
    func webLogin() {
        if let accessToken = UserDefaults.standard.string(forKey: "access_token") {
            webLoginManager.webLogin(accessToken: accessToken, pin: scannedCode, callback: self)
        } else {
            appState.showView(ScreenView.login)
        }
    }
    
    func qrScanFailed() {
        appState.showToast("QR code scan failure", AlertType.error, true)
    }
    
    private func loading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = isLoading
        }
    }
        
    // WebLoginCallback methods
    func showError(webLoginErrorCode: WebLoginErrorCode, errorMessage: String) {
        
        DispatchQueue.main.async {
            self.isLoading = false
            self.appState.showToast(errorMessage, AlertType.error, true)
        }
    }
    
    func onSuccess() {
        
        
        DispatchQueue.main.async {
            self.appState.showToast("WebLogin successful", AlertType.success, true)
            
            // Delay the navigation to allow the toast to be visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust the duration as needed
                self.appState.showView(ScreenView.webLoginApprove)
                self.loading(false)
            }
        }
        
        
    }
}
