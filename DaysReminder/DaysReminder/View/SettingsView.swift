//
//  SettingsView.swift
//  DaysReminder
//
//  Created by zhang on 04/12/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: DateEntryViewModel
    
    @State private var selectedSortOption: SortOption = .chronological
    @State private var filterTag: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort by")) {
                    Picker("Sort", selection: $selectedSortOption) {
                        Text("Chronological").tag(SortOption.chronological)
                        Text("Creatuib Date").tag(SortOption.byCreationDate)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Filter by Tag")) {
                    TextField("Enter tag to filter", text: $filterTag)
                }
                
                Section {
                    Button("Apply Settings") {
                        applySettings()
                    }
                }
                
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.clearFilter()
                    }
                }
            }
            .onAppear {
                loadSettings()
            }
        }
    }
    
    private func loadSettings() {
        selectedSortOption = viewModel.sortOption
        filterTag = viewModel.filterTag ?? ""
    }
    
    private func applySettings() {
        viewModel.changeSortOption(to: selectedSortOption)
        viewModel.filterEntries(by: filterTag.isEmpty ? nil : filterTag)
    }
}
