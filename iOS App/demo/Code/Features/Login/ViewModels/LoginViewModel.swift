//
//  LoginViewModel.swift
//  demo
//
//  Created by Angel on 9/4/24.
//

import Foundation
import BiometricAuthentication
import LocalAuthentication

class LoginViewModel: ObservableObject, SignInCallback {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoginVisible: Bool = true
    @Published var toastMessage: String = ""
    @Published var showToast: Bool = false
    @Published var isLoggedIn: Bool = false
    
    @Published var isBiometrics: Bool = true
    
    var appState: AppState
    
    private var signInManager: SignIn
    
    init(appState: AppState) {
        self.signInManager = SignIn(apiKey: CONSTANTS.apiKey)
        self.appState = appState
        self.appState.showToast = false
        //        signInManager.checkLastUser(callback: self)
    }
    
    private func loading() {
        isLoading = true
        isLoginVisible = false
    }
    
    private func loginVisible() {
        DispatchQueue.main.async {
            self.isLoginVisible = true
            self.isLoading = false
        }
    }
    
    //    login button clicked
    func handleLogin() {
        signIn()
    }
    
    private func signIn() {
        if isValidEmail(email) {
            loading()
            signInManager.signIn(userid: email, callback: self)
        } else {
            toastMessage = "Enter a valid email address"
            appState.showToast(toastMessage, AlertType.error, true)
        }
    }
    
    // SignInCallback methods
    func showError(signInErrorCode: SignInErrorCode, errorMessage: String) {
        
        DispatchQueue.main.async {
            self.appState.showToast(errorMessage, AlertType.error, true)
            
            // Delay for user to see the error message before any navigation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                switch signInErrorCode {
                case .userNotFound:
                    self.appState.showView(ScreenView.signup)
                    self.loginVisible()
                case .resetDevice:
                    self.appState.showView(ScreenView.reset)
                default:
                    self.loginVisible()
                }
            }
        }
        
        
    }
    
    func onSuccessfulLogin(_ loggedInEmail: String) {
        DispatchQueue.main.async {
            self.appState.showToast("Login successful", AlertType.success, true)
            
            // Delay the navigation to allow the toast to be visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust the duration as needed
                self.appState.showView(ScreenView.home)
            }
        }
        
        // Store the logged-in email
        UserDefaults.standard.set(loggedInEmail, forKey: "email")
    }
    
    func showEmailSignInScreen() {
        loginVisible()
    }
    
    func authenticate() {
        if appState.isFirstLogin {
            biometrics()
        }
    }
    
    func biometrics() {
        let context = LAContext()
        var error: NSError?
        print("authenticate")
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            //            self.appState.showToast(reason, AlertType.error, true)
            
            if UserDefaults.standard.string(forKey: "email") != nil {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    // authentication has now completed
                    if success {
                        // authenticated successfully
                        let user = UserDefaults.standard.string(forKey: "email") ?? ""
                        self.signInManager.signIn(userid: user, callback: self)
//                        self.appState.showView(ScreenView.home)
                    } else {
                        // there was a problem
                        self.appState.showToast("Couldn't verify the user", AlertType.error, true)
                    }
                }
            }
            
        } else {
            // no biometrics
            self.appState.showToast("Device does not support biometrics", AlertType.error, true)
        }
    }
    
}
