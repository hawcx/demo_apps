//
//  Toast.swift
//  demo
//
//  Created by Angel on 9/2/24.
//

import SwiftUI

struct Toast: View {
    var message: String
    @Binding var isShowing: Bool
    var body: some View {
        if isShowing {
            Text(message)
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
                .transition(.slide)
                .animation(.easeInOut, value: isShowing)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
        }
    }
}
