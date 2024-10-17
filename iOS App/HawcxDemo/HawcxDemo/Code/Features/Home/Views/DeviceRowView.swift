//
//  DeviceRow.swift
//  demo
//
//  Created by dev on 10/9/24.
//

import SwiftUI

struct DeviceRow: View {
    var device: Device
    
    var body: some View {
        HStack {
            Image(systemName: getDeviceTypeIcon(device.deviceType))
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            
            VStack(alignment: .leading) {
                Text(device.deviceType)
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text(device.osDetails)
                    .font(.subheadline)
                    .foregroundColor(.green)
                
                if !device.browserWithVersion.isEmpty {
                    Text(device.browserWithVersion)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}
