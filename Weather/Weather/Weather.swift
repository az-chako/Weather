//
//  Weather.swift
//  Weather
//
//  Created by spark-03 on 2024/05/24.
//

import Foundation
import YumemiWeather

protocol YumemiDelegate {
    func setWeatherImages(type: String)
    func setWeatherTemprature(minTemprature: Int, maxTemprature: Int)
    func setWeatherError(error: Error)
}

class WeatherManager {
    var delegate: YumemiDelegate?
    
    let requestJson = """
    {
    "area": "Tokyo","date": "2020-04-01T12:00:00+09:00"
    }
    """
    
    func updateWeather() {
        do {
            let weatherData = try YumemiWeather.fetchWeather(requestJson)
            guard let data = weatherData.data(using: .utf8) else { return }
            if let weatherDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let minTemprature = weatherDictionary["min_temperature"] as? Int,
                      let maxTemprature = weatherDictionary["max_temperature"] as? Int,
                      let weatherCondition = weatherDictionary["weather_condition"] as? String else { return }
                delegate? .setWeatherImages(type: weatherCondition)
                delegate? .setWeatherTemprature(minTemprature: minTemprature, maxTemprature: maxTemprature)
            }
        } catch {
            self.delegate?.setWeatherError(error: error)
        }
    }
}
