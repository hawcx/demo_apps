//
//  Helpers.swift
//  demo
//
//  Created by Angel on 9/2/24.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

func isValidOTP(_ otp: String) -> Bool {
    if otp.count == 6 && otp.allSatisfy({$0.isNumber}) {
        return true
    } else {
        return false
    }
}

func isValidPin(_ pin: String) -> Bool {
    if pin.count == 7 && pin.allSatisfy({$0.isNumber}) {
        return true
    } else {
        return false
    }

}

func getDeviceTypeIcon(_ deviceType: String) -> String {
    let deviceTypeIcons: [String: String] = [
        "Mobile": "iphone",             // SF Symbol for iPhone
        "Tablet": "ipad",               // SF Symbol for iPad
        "Desktop": "desktopcomputer",    // SF Symbol for Desktop Computer
        "Smart TV": "tv",               // SF Symbol for TV
        "Windows Desktop": "pc",        // SF Symbol for Windows PC
        "Mac Desktop": "macmini",       // SF Symbol for Mac
        "iOS Device": "iphone",         // SF Symbol for iPhone
        "Android Device": "android.logo", // Android logo (custom)
        "Unknown": "questionmark"       // SF Symbol for Question Mark
    ]
    
    // Check for iPhone specifically
    if deviceType.contains("iPhone") {
        return "iphone"
    }
    
    // Return the corresponding icon or the question mark symbol for unknown types
    return deviceTypeIcons[deviceType, default: "questionmark"]
}

func getOsIcon(_ osDetails: String) -> String {
//    let osIcons: [String: String] = [
//        "Windows": "windows",
//        "Mac OS": "applelogo",           // SF Symbol for Apple
//        "Linux": "tortoise.fill",        // Custom symbol for Linux
//        "Android": "android.logo",       // Custom symbol for Android
//        "Ubuntu": "ubuntu",              // Custom symbol for Ubuntu
//        "Chrome": "circle.fill",         // SF Symbol (you might choose a different one)
//        "Firefox": "flame",              // SF Symbol (you might choose a different one)
//        "Freebsd": "network",            // Custom symbol for FreeBSD
//        "Blackberry": "phone.fill",      // Custom symbol for Blackberry
//        "Raspberry Pi": "raspberrypi",   // Custom symbol for Raspberry Pi
//        "CentOS": "cylinder.fill",        // Custom symbol for CentOS
//        "iOS": "applelogo"               // SF Symbol for iOS
//    ]
//    
//    return osIcons[osDetails, default: "iphone"] // Fallback to a mobile symbol
    return "iphone"
}
