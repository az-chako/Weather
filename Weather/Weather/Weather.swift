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
    func didFailWithError(error: Error)
}

class WeatherManager {
    var delegate: YumemiDelegate?
    
    func updateWeather(){
        do {
            let weather = try YumemiWeather.fetchWeatherCondition(at:"")
            self.delegate? .setWeatherImages(type: weather)
        } catch {
            self.delegate?.didFailWithError(error : error)
        }
    }
}
