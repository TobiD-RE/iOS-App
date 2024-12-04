//
//  ContentView.swift
//  Quotes
//
//  Created by zhang on 08/11/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.orange, .pink, .mint], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
                .opacity(0.6)
            
            VStack {
                Image(systemName: "bubble.fill")
                    .renderingMode(.template)
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Quotes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(Color.accentColor)
                    .background(Color.secondary.opacity(0.3))
                    .cornerRadius(15.0)
                    .shadow(radius: 5, x: 5, y: 5)
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
