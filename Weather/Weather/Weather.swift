//
//  Weather.swift
//  Weather
//
//  Created by spark-03 on 2024/05/24.
//

import Foundation
import YumemiWeather

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
