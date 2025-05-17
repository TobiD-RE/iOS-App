//
//  View.swift
//  Weather
//
//  Created by zhang on 17/05/2025.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.6)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2)
            
            Text("Loading Weather Data...")
                .foregroundColor(.white)
                .font(.title2)
                .padding(.top, 20)
        }
    }
}

struct ErrorView: View {
    let errorMessage: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.trangle")
                .font(.system(size: 50))
                .foregroundColor(.white)
            
            Text(errorMessage)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again") {
                
            }
            .padding()
            .background(Color.white)
            .foregroundColor(.blue)
            .cornerRadius(10)
        }
    }
}

struct InitialView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.circle")
                .font(.system(size: 50))
                .foregroundColor(.white)
            
            Text("Welcome to Weather App")
                .font(.title)
                .foregroundColor(.white)
            
            Text("We'll need your location to provide weather information")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

struct WeatherView: View {
    let weather: WeatherModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(weather.cityName)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
                
                HStack {
                    AsyncImage(url: weather.iconURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                        } else {
                            ProgressView()
                        }
                    }
                        
                    Text(weather.temperatureString)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                        
                    VStack(spacing: 15) {
                        WeatherDetailRow(symbol: "thermometer", title: "Feels like", value: weather.feelsLikeString)
                        WeatherDetailRow(symbol: "wind", title: "Wind Speed", value: "\(weather.windSpeed) m/s")
                        WeatherDetailRow(symbol: "humidity", title: "Humidity", value: "\(weather.humidity)%")
                        WeatherDetailRow(symbol: "sunrise", title: "Sunrise", value: weather.sunriseTime)
                        WeatherDetailRow(symbol: "sunset", title: "Sunset", value: weather.sunsetTime)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
    }
}

struct WeatherDetailRow: View {
    let symbol: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: symbol)
                .font(.title2)
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}
