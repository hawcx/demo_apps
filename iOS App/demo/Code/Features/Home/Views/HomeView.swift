//
//  HomeView.swift
//  demo
//
//  Created by Angel on 9/4/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: MainViewModel
    
    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: MainViewModel(appState: appState))
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        viewModel.handleWebLogin()
                    }){
                        Image("qrscan")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .padding(.horizontal, 12)
                    }
                    
                    Text("Home")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 12)
                    
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Text("Logout")
                            .padding()
                    }
                }
                .foregroundColor(.black)
                
                
                Divider()
                    .background(Color.black)
            }
            .frame(maxWidth: .infinity)
            
            
            ScrollView{
                VStack {
                    HStack {
                        Text("Welcome to Hawcx")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(Color.blue)
                    .padding(.top, 30)
                    
                    Text(viewModel.loggedEmail)
                        .font(.title3)
                        .foregroundColor(Color.white.opacity(0.8))
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        viewModel.appState.showView(ScreenView.homeDeviceList)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(appState: AppState())
    }
}

