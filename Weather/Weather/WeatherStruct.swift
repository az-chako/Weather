//
//  WeatherStruct.swift
//  Weather
//
//  Created by spark-03 on 2024/05/29.
//

import Foundation

struct WeatherDate: Codable {
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

struct TableViewRequest: Codable {
    let areas: [String]
    let date: String
}

struct AreaResponse: Codable {
    let area: String
    let info: Weather
}
