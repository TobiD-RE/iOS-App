//
//  ContentView.swift
//  DaysReminder
//
//  Created by zhang on 31/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color
                .mint
                .opacity(0.3)
                .ignoresSafeArea()
            VStack {
                Image(systemName: "calendar.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .padding()
                Text("Here marks the beginning of making MY DaysReminder")
                    .multilineTextAlignment(.center)
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
