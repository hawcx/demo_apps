//
//  MainViewModel.swift
//  demo
//

//  Created by Angel on 9/5/24.
//

import Foundation
import HawcxFramework

struct Device: Codable, Identifiable, Hashable {
    let id = UUID()
    let devId: String
    let osDetails: String
    let browserWithVersion: String
    let deviceType: String
    let sessionDetails: [Session]
    
    enum CodingKeys: String, CodingKey {
        case devId = "dev_id"
        case osDetails = "os_details"
        case browserWithVersion = "browser_with_version"
        case deviceType = "device_type"
        case sessionDetails = "session_details"
    }
}

struct Session: Codable, Identifiable, Hashable {
    let id = UUID()
    let country: String
    let ipDetails: String
    let isp: String
    let sessionLoginTime: String
    let osDetails: String
    
    enum CodingKeys: String, CodingKey {
        case country
        case ipDetails = "ip_details"
        case isp
        case sessionLoginTime = "session_login_time"
        case osDetails = "os_details"
    }
}


class MainViewModel: ObservableObject, DevSessionCallback {
    @Published var loggedEmail: String
    @Published var isLoading: Bool = true
    @Published var devices: [Device] = []
    
    var appState: AppState
    var devSession: DevSession
    
    init(appState: AppState) {
        self.appState = appState
        self.loggedEmail = UserDefaults.standard.string(forKey: "email") ?? ""
        self.appState.showToast = false
        self.appState.isFirstLogin = false
        UserDefaults.standard.set(true, forKey: "loggedInBefore")
        self.devSession = DevSession(apiKey: CONSTANTS.apiKey)
        devSession.GetDeviceDetails(callback: self)
    }
    
    func loadDevices() {
        devSession.GetDeviceDetails(callback: self)
    }
    
    func onSuccess() {
        isLoading = false
        
        do {
            if let savedData = UserDefaults.standard.data(forKey: "devDetails") {
                let decoder = JSONDecoder()
                
                let devDetails = try decoder.decode([Device].self, from: savedData)
//                print(devDetails)
                
                DispatchQueue.main.async { [weak self] in
                    self?.devices = devDetails

                }
                //                self.devices = devDetails
                
                //                let devId: String
                //                let osDetails: String
                //                let browserWithVersion: String
                //                let deviceType: String
                
                //                deviceText = sessionDetails.deviceType
                //                osText = sessionDetails.osDetails
                //                browserText = sessionDetails.browserWithVersion
                //                locationText = sessionDetails.city + ", " + sessionDetails.state + ", " + sessionDetails.country
            } else {
                print("No session details found")
            }
        }
        catch {
            print("Failed to retrieve or decode session details: \(error)")
        }
    }
    
    func showError() {
        
    }
    
    func logout() {
        // Handle logout action
        UserDefaults.standard.set(true, forKey: "is_logged_out")
        
        
        DispatchQueue.main.async {
            //self.appState.showToast("Logout successful", AlertType.success, true)
            self.appState.showView(ScreenView.login)
            // Delay the navigation to allow the toast to be visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust the duration as needed
                self.appState.showToast("Logout successful", AlertType.success, true)
            }
        }
    }
    
    func handleWebLogin() {
        appState.showView(ScreenView.weblogin)
    }
}
