//
//  WeatherList.swift
//  Weather
//
//  Created by spark-03 on 2024/06/03.
//

import Foundation
import YumemiWeather

class WeatherList{
    func areaWeather(completion: @escaping(Result<[AreaResponse], Error>) -> Void) {
        DispatchQueue.global().async {
            let date = Date().ISO8601Format()
            let requestJson = TableViewRequest(areas: [], date: date)
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(requestJson)
                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                    return
                }
                let weatherList = try YumemiWeather.syncFetchWeatherList(jsonString)
                guard let jsonData = weatherList.data(using:.utf8) else {
                    return
                }
                let decoder = JSONDecoder()
                let areaResponses = try decoder.decode([AreaResponse].self, from: jsonData)
                completion(.success(areaResponses))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
}
