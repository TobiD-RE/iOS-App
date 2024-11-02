//
//  DateDetailView.swift
//  DaysReminder
//
//  Created by zhang on 02/11/2024.
//  Deatils for a selected DateEntry

import SwiftUI

struct DateDetailView: View {
    @ObservedObject var entry: DateEntry
    @ObservedObject var viewModel: DateEntryViewModel
    @State private var isPresentingEditView = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(entry.title)
                .font(.largeTitle)
                .padding()
            
            Text("Date: \(entry.date, formatter: DateFormatter.shortDate)")
                .font(.title2)
            
            Text("Days \(entry.date > Date() ? "until" : "since"): \(Calendar.current.dateComponents([.day], from: Date(), to: entry.date).day ?? 0)")
                .font(.title3)
                .padding()
            
            if entry.notificationEnabled {
                Text("Notification set for \(entry.notificationTime ?? Date(), formatter: DateFormatter.timeOnly)")
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            //Edit and delete button
            HStack {
                Button("Edit") {
                    isPresentingEditView.toggle()
                }
                .padding()
                .sheet(isPresented: $isPresentingEditView) {
                    Alert(
                        title: Text("Delete Entry"),
                        message: Text("Are you sure you want to delete this event?"),
                        primaryButton: .destructive(Text("Delete")) {
                            viewModel.deleteEntry(entry)
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationTitle(entry.title)
        .padding()
    }
}

//Formatter Extensions

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

