//
//  LineView.swift
//  demo
//
//  Created by Angel on 8/29/24.
//

import SwiftUI

struct LineView: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView()
    }
}
