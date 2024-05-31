//
//  Weather.swift
//  Weather
//
//  Created by spark-03 on 2024/05/24.
//

import Foundation
import YumemiWeather

class WeatherManager {
    func updateWeather(completion: @escaping (Result<Weather, Error>) -> Void) {
        let requestJson = Date(area:"tokyo", date: "2020-04-01T12:00:00+09:00")
        
        DispatchQueue.global().async {
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(requestJson)
                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                    return
                }
                
                let weatherData = try YumemiWeather.syncFetchWeather(jsonString)
                
                guard let jsonData = weatherData.data(using: .utf8) else {
                    return
                }
                let decoder = JSONDecoder()
                let weather = try decoder.decode(Weather.self, from: jsonData)
                completion(.success(weather))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
}
