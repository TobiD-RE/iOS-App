//
//  DateFormView.swift
//  DaysReminder
//
//  Created by zhang on 04/12/2024.
//

import SwiftUI

struct DateFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: DateEntryViewModel
    @ObservedObject var entry: DateEntry
    
    @State private var title: String = ""
    @State private var selectedDate: Date = Date()
    @State private var isAnniversary: Bool = false
    @State private var tag: String = ""
    @State private var notificationEnabled: Bool = false
    @State private var notificationTime: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                
                Section(header: Text("Date")) {
                    DatePicker("Select date", selection: $selectedDate, displayedComponents: [.date])
                }
                
                Section{
                    Toggle("Is Anniversary", isOn: $isAnniversary)
                }
                
                Section(header: Text("Tag")) {
                    TextField("Enter tag", text: $tag)
                }
                
                Section(header: Text("Notification")) {
                    Toggle("Enable Notification", isOn: $notificationEnabled)
                    if notificationEnabled {
                        DatePicker("Time", selection: $notificationTime, displayedComponents: [.hourAndMinute])
                    }
                }
            }
            .navigationTitle(entry.isInserted ? "Edit Entry" : "New Entry")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancle") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                if entry.isInserted { loadEntryData() }
            }
        }
    }
    
    private func loadEntryData() {
        title = entry.title ?? ""
        selectedDate = entry.date ?? Date()
        isAnniversary = entry.isAnniversary
        tag = entry.tag ?? ""
        notificationEnabled = entry.notificationEnabled
        notificationTime = entry.notificationTime ?? Date()
    }
    
    private func saveEntry() {
        if entry.isInserted {
            viewModel.updateEntry(entry, title: title, date: selectedDate, isAnniversary: isAnniversary, tag: tag, notificationEnabled: notificationEnabled, notificationTime: notificationTime)
        } else {
            viewModel.addEntry(title: title, date: selectedDate, isAnniversary: isAnniversary, tag: tag, notificationEnabled: notificationEnabled, notificationTime: notificationTime)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
