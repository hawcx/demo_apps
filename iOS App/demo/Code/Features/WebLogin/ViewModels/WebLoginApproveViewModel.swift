//
//  WebLoginApproveViewModel.swift
//  demo
//
//  Created by Angel on 9/24/24.
//

import Foundation

class WebLoginApproveViewModel: ObservableObject, WebLoginCallback {
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var deviceText: String = "Device: iPhone 12"
    @Published var osText: String = "OS: iOS 14"
    @Published var browserText: String = "Browser: Safari"
    @Published var locationText: String = "Location: Toronto, Canada"
    @Published var timeText: String = "Time: Sep 24, 2024 - 10:15 AM"
    
    var appState: AppState
    
    private var webLoginManager: WebLoginManager
    
    init(appState: AppState) {
        self.webLoginManager = WebLoginManager(apiKey: CONSTANTS.apiKey)
        self.appState = appState
        self.appState.showToast = false
        do {
            if let savedData = UserDefaults.standard.data(forKey: "sessionDetails") {
                let decoder = JSONDecoder()
                
                let sessionDetails = try decoder.decode(SessionDetails.self, from: savedData)
                
                deviceText = sessionDetails.deviceType
                osText = sessionDetails.osDetails
                browserText = sessionDetails.browserWithVersion
                locationText = sessionDetails.city + ", " + sessionDetails.state + ", " + sessionDetails.country
            } else {
                print("No session details found")
            }
        }
        catch {
            print("Failed to retrieve or decode session details: \(error)")
        }
        
    }
    
    //Approve button clicked
    func handleApprove() {
        webApprove()
    }
    
    //Reject button clicked
    func handleReject() {
        appState.showView(ScreenView.home)
    }
    
    private func webApprove() {
        loading(true)
        if let accessToken = UserDefaults.standard.string(forKey: "access_token"),
           let webToken = UserDefaults.standard.string(forKey: "web_token") {
            webLoginManager.webApprove(accessToken: accessToken, token: webToken, callback: self)
        }
        else {
            appState.showView(ScreenView.weblogin)
        }
    }
    
    private func loading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = isLoading
        }
    }
    
    // WebLoginCallback methods
    func showError(webLoginErrorCode: WebLoginErrorCode, errorMessage: String) {	

        DispatchQueue.main.async {
            self.appState.showToast(errorMessage, AlertType.error, true)
            self.isLoading = false
        }
    }
    
    func onSuccess() {
        DispatchQueue.main.async{
            self.appState.showView(ScreenView.home)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                self.appState.showToast("WebLogin successful", AlertType.success, true)
                self.isLoading = false
            }
        }
    }
}
