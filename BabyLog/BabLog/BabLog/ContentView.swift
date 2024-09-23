//
//  ContentView.swift
//  BabLog
//
//  Created by zhang on 23/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State var sideBar = false
    
    var body: some View {
        ZStack{
            NavigationView {
                VStack {
                    Text("Welcome to BabLog")
                        .font(.title)
                        .padding()
                    
                    Spacer()
                }
                .navigationTitle("Is it happening?") // Title of the navigation bar
                .navigationBarTitleDisplayMode(.inline) // Makes the title appear inline (small size)
                .toolbar {
                    // Leading button (e.g., a settings button)
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            sideBar.toggle()
                        }) {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                    
                    // Trailing button (e.g., an add button)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("Add tapped")
                        }) {
                            Image(systemName: "note.text")
                        }
                    }
                }
            }
            if sideBar {
                SideBarView()
                    .transition(.move(edge: .leading)) // Slide in from the left
                    .zIndex(1) // Ensures the sidebar is above the main content
                    .onTapGesture {
                    // Hide the sidebar when tapped outside
                        withAnimation {
                            sideBar = false
                            }
                    }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
