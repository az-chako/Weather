//
//  Weather.swift
//  Weather
//
//  Created by spark-03 on 2024/05/24.
//

import Foundation
import YumemiWeather

struct Date: Codable {
    let area: String
    let date: String
}

struct Weather: Codable {
    let weatherImage: String
    let minTemperature: Int
    let maxTemperature: Int
    enum CodingKeys: String, CodingKey {
        case weatherImage = "weather_condition"
        case minTemperature = "min_temperature"
        case maxTemperature = "max_temperature"
    }
}
protocol YumemiDelegate {
    func setWeather(weather: Weather)
    func setWeatherError(error: Error)
}

class WeatherManager {
    var delegate: YumemiDelegate?
    
    func updateWeather() {
        let requestJson = Date(area:"tokyo", date: "2020-04-01T12:00:00+09:00")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(requestJson)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                return
            }
            
            let weatherData = try YumemiWeather.fetchWeather(jsonString)
            
            guard let jsonData = weatherData.data(using: .utf8) else {
                return
            }
            let decoder = JSONDecoder()
            let weather = try decoder.decode(Weather.self, from: jsonData)
            delegate?.setWeather(weather: weather)
        } catch {
            self.delegate?.setWeatherError(error: error)
        }
    }
}
