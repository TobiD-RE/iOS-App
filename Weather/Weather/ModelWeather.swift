//
//  ModelWeather.swift
//  Weather
//
//  Created by zhang on 17/05/2025.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: Double
    let feelsLike: Double
    let description: String
    let iconCode: String
    let sunrise: Int
    let sunset: Int
    let windSpeed: Double
    let humidity: Int
    
    var temperatureString: String {
        return String(format: "%.1fºC", temperature)
    }
    
    var feelsLikeString: String {
        return String(format: "%.1fºC", feelsLike)
    }
    
    var iconURL: URL {
        return URL(string: "http://openweathermap.org/img/wn/\(iconCode)@2x.png")!
    }
    
    var sunriseTime: String {
        let date = Date(timeIntervalSince1970: Double(sunrise))
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    var sunsetTime: String {
        let date = Date(timeIntervalSince1970: Double(sunset))
        let formatter = DateFormatter()
        formatter .dateFormat = "h: mm a"
        return formatter.string(from: date)
    }
}

struct WeatherResponse: Decodable {
    let name: String
    let main: MainWeather
    let weather: [WeatherInfo]
    let sys: SysInfo
    let wind: WindInfo
}

struct MainWeather: Decodable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
}

struct WeatherInfo: Decodable {
    let description: String
    let icon: String
}

struct SysInfo: Decodable {
    let sunrise: Int
    let sunset: Int
}

struct WindInfo: Decodable {
    let speed: Double
}
