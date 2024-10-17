//
//  ContentView.swift
//  HawcxDemo
//
//  Created by dev on 10/15/24.
//

import SwiftUI
import AlertToast

struct ContentView: View {
    @StateObject var appState: AppState
    
  
    
    var body: some View {
        NavigationView {
            switch (appState.showScreen) {
            case ScreenView.home:
                HomeView(appState: appState)
            case ScreenView.signup:
                SignUpView(appState: appState)
            case ScreenView.login:
                LoginView(appState: appState)
            case ScreenView.reset:
                ResetView(appState: appState)
            case ScreenView.weblogin:
                WebLoginView(appState: appState)
            case ScreenView.webLoginManual:
                WebLoginManual(appState: appState)
            case ScreenView.webLoginQRScanner:
                WebLoginQRScanner(appState: appState)
            case ScreenView.webLoginApprove:
                WebLoginApprove(appState: appState)
            case ScreenView.homeDeviceList:
                DeviceListView(appState: appState)
            
            }
        }.toast(isPresenting: $appState.showToast, duration: 2, tapToDismiss: true) {
            switch appState.alertType {
            case .success:
                AlertToast(displayMode:.banner(.pop), type: .complete(.green),  title: appState.alertTitle, style: appState.successStyle)
            case .error:
                AlertToast(displayMode:.banner(.pop), type: .error(.red),  title: appState.alertTitle, style: appState.errorStyle)
            default:
                AlertToast(displayMode:.banner(.pop), type: .error(.red),  title: appState.alertTitle, style: appState.errorStyle)
            }
        }
    }
}


#Preview {
    ContentView(appState: AppState())
}
