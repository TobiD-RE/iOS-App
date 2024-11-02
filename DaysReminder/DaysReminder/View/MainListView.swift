//
//  MainList.swift
//  DaysReminder
//
//  Created by zhang on 02/11/2024.
//
//  Display a list of date entries
//  Using DateEntryViewModel


import SwiftUI

struct MainListView: View {
    @StateObject private var viewModel = DateEntryViewModel()
    @State private var isPresentingNewEntryView = false
    @State private var selectedSortOption: SortOption = .chronological
    @State private var selectedFilterTag: String? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                // Sort & Filter
                
                HStack {
                    //Sort
                    
                    Picker("Sort By", selection: $selectedSortOption) {
                        Text("Chronological").tag(SortOption.chronological)
                        Text("Creation Date").tag(SortOption.byCreationDate)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedSortOption) { newSortOption in
                        viewModel.changeSortOption(to: newSortOption)
                    }
                    
                    //Filter
                    
                    Button("Filter") {
                        
                    }
                }
                .padding()
                
                //Entries
                
                List(viewModel.dateEntries) { entry in
                    NavigationLink(destination: DateDetailView(entry: entry, viewModel: viewModel)) {
                        DateEntryRow(entry: entry)
                    }
                }
                .listStyle(PlainListStyle())
                
                //Add new button
                
                Button(action: {
                    isPresentingNewEntryView.toggle()
                }) {
                    Label("Add new", systemImage: "plus.circle")
                }
                .padding()
                .sheet(isPresented: $isPresentingNewEntryView) {
                    NewEntryView(viewModel: viewModel)
                }
            }
            .navigationTitle("Days Reminder")
        }
    }
    
}

//Subview

struct DateEntryRow: View {
    
    let entry: DateEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.headline)
            Text("Days \(entry.date > Date() ? "Until" : "Since"): \(Calendar.current.dateComponents([.day], from: Date(), to: entry.date).day ?? 0)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
