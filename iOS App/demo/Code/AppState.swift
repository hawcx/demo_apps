//
//  AppState.swift
//  demo
//
//  Created by Angel on 9/20/24.
//

import Foundation
import AlertToast


enum ScreenView: String {
    case login = "LOGIN_VIEW"
    case signup = "SIGNUP_VIEW"
    case reset = "RESET_DEVICE_VIEW"
    case weblogin = "WEB_LOGIN_VIEW"
    case home = "HOME_VIEW"
    case webLoginManual = "WEB_LOGIN_MANUAL_VIEW"
    case webLoginApprove = "WEB_LOGIN_APPROVE_VIEW"
    case webLoginQRScanner = "WEB_LOGIN_QRSCANNER_VIEW"
    case homeDeviceList = "HOME_DEVICE_LIST_VIEW"
}

enum AlertType {
    case success
    case error
    case loading
}


class AppState: ObservableObject {
//    @Published var showWebLogin = false
//    @Published var showWebLoginManual = false
//    @Published var showWebLoginApprove = false
    
    @Published var showScreen = ScreenView.signup
    @Published var successStyle = AlertToast.AlertStyle.style(backgroundColor: .green, titleColor: .white, subTitleColor: .white)
    @Published var errorStyle = AlertToast.AlertStyle.style(backgroundColor: .red, titleColor: .white, subTitleColor: .white)
    
    @Published var alertTitle: String = ""
    @Published var alertSubTitle: String = ""
    @Published var showToast:Bool = false
    @Published var alertType: AlertType? = nil
    
    @Published var isFirst: Bool = false
    @Published var isFirstLogin: Bool = true
    
    @Published var isBiometricsEnable: Bool = false
    
    init() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            isFirst = false
        } else {
            isFirst = true
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        showScreen = isFirst ? ScreenView.signup : ScreenView.login
        
        let loggedInBefore = UserDefaults.standard.bool(forKey: "loggedInBefore")
        
        if loggedInBefore {
            isFirstLogin = false
        } else {
            isFirstLogin =  true
        }
    }
    
    func showView(_ screenView: ScreenView) {
        showScreen = screenView
    }
    
    func showToast(_ title: String, _ type: AlertType, _ show: Bool) {
        print("*****", title, show, type)
        
        alertTitle = title
        alertType = type
        showToast = show
    }
    
}
