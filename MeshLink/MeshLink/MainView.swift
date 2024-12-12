//
//  MainView.swift
//  MeshLink
//
//  Created by zhang on 11/12/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: DeviceMatchingView()) {
                    Text("Match Devices")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.mint)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: ChatView()) {
                    Text("Start Chat")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: HistoryView()) {
                    Text("View History")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }
                .padding(.horizontal)
                
                Spacer()
                
            }
            .navigationTitle("Main Screen")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
