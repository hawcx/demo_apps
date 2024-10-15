//
//  DeviceListView.swift
//  demo
//
//  Created by dev on 10/9/24.
//

import SwiftUI

struct DeviceListView: View {
    
    @StateObject var viewModel: MainViewModel
    @State private var isVisible = false
    
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
            
            if isVisible {
                
                ScrollView{
                    VStack {
                        
                        if isVisible {
                            HStack {
                                Text("Welcome to Hawcx")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()
                            .transition(.move(edge: .top)) // Sliding from the top
                            .animation(.easeInOut, value: isVisible)
                            
                            Text(viewModel.loggedEmail)
                                .font(.title3)
                                .foregroundColor(Color.white.opacity(0.8))
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .transition(.move(edge: .top))
                                .animation(.easeInOut, value: isVisible)
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
                    .onAppear {
                        // Show the notification
                        withAnimation {
                            isVisible = true
                        }
                        
                        // Hide the notification after 3 minutes (180 seconds)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                isVisible = false
                            }
                        }
                        
                    }
                }
                
            }
            
            
            if !isVisible {
                List {
                    ForEach(viewModel.devices, id: \.self) { device in
                        NavigationLink(destination: SessionDetailView(sessions: device.sessionDetails)) {
                            DeviceRow(device: device)
                        }
                        
                    }
                    
                }
                .listStyle(InsetGroupedListStyle())
                
            }
        }
        
        
    }
}

#Preview {
    DeviceListView(appState: AppState())
}
