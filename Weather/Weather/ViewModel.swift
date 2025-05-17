//
//  ViewModel.swift
//  Weather
//
//  Created by zhang on 17/05/2025.
//

import Foundation
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    @Published var currentWeather: WeatherModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let locationManager = CLLocationManager()
    private let apiKey = "5f237229ba84282d4216e74bd6e5b968" //OpenweatherMap
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        isLoading = true
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            isLoading = false
            errorMessage = "Location access is restricted. Please enable it in settings"
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            isLoading = false
            errorMessage = "Unexpected error with location services"
        }
    }
    
    private func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            isLoading = false
            errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    let weatherModel = WeatherModel(
                        cityName: weatherResponse.name,
                        temperature: weatherResponse.main.temp,
                        feelsLike: weatherResponse.main.feels_like,
                        description: weatherResponse.weather.first?.description ?? "",
                        iconCode: weatherResponse.weather.first?.icon ?? "",
                        sunrise: weatherResponse.sys.sunrise,
                        sunset: weatherResponse.sys.sunset,
                        windSpeed:weatherResponse.wind.speed,
                        humidity:weatherResponse.main.humidity
                    )
                    self.currentWeather = weatherModel
                } catch {
                    self.errorMessage = "Failed to parse weather data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        isLoading = false
        errorMessage = "Failed to get location: \(error.localizedDescription)"
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            isLoading = false
            errorMessage = "Location access is restricted. Please enable it in settings."
        case .notDetermined:
            break
        @unknown default:
            isLoading = false
            errorMessage = "Unexpected error with location services."
        }
    }
}
