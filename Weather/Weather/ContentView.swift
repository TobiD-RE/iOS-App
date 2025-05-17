//
//  ContentView.swift
//  Weather
//
//  Created by zhang on 17/05/2025.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                BackgroundView()
                
                VStack{
                    if weatherViewModel.isLoading{
                        LoadingView()
                    } else if let weather = weatherViewModel.currentWeather {
                        WeatherView(weather: weather)
                    } else {
                        if let error = weatherViewModel.errorMessage {
                            ErrorView(errorMessage: error)
                        } else {
                            InitialView()
                        }
                    }
                }
            }
            .navigationTitle("Weather")
        }
        .onAppear {
            weatherViewModel.requestLocation()
        }
    }
}

#Preview {
    ContentView()
}
