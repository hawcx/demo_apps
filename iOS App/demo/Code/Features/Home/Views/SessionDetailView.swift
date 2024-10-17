//
//  SessionDetailView.swift
//  demo
//
//  Created by dev on 10/8/24.
//

import SwiftUI

struct SessionDetailView: View {
    var sessions: [Session]  // The session object being passed
    
    var body: some View {
        List(sessions) { session in
            HStack {
                Image(systemName: getOsIcon(session.osDetails))
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text(session.ipDetails)
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Text(session.country)
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    Text(session.sessionLoginTime)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Text(session.isp)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: .gray, radius: 5, x: 0, y: 2)
        }
        .navigationTitle("Session Details")
    }
}
