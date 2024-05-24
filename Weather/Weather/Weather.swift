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
}

class WeatherManager {
    var delegate: YumemiDelegate?
    
    func updateWeather() {
        let weather = YumemiWeather.fetchWeatherCondition()
        delegate?.setWeatherImages(type: weather)
    }
}
