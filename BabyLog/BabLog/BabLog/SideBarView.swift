//
//  SideBarView.swift
//  BabLog
//
//  Created by zhang on 23/09/2024.
//

import SwiftUI

struct SideBarView: View {
    var body: some View {
        VStack(alignment: .leading){
            Image(systemName: "photo.fill")
            Text("Name of the baby")
                .padding()
            Spacer()
            Button(action: {
                print("setting")
            }) {
                Image(systemName: "gear")
            }
        }
    }
}
