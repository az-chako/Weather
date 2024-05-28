//
//  ViewController.swift
//  Weather
//
//  Created by spark-03 on 2024/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
    }
    
    @IBAction func reloadBtn(_ sender: Any) {
        weatherManager.updateWeather()
    }
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension ViewController: YumemiDelegate {
    
    func setWeather(weather: Weather) {
        weatherImg.image = UIImage(named: weather.weatherImage)?.withRenderingMode(.alwaysTemplate)
        switch weather.weatherImage {
        case "sunny":
            weatherImg.tintColor = .red
        case "cloudy":
            weatherImg.tintColor = .gray
        case "rainy":
            weatherImg.tintColor = .blue
        default:
            break
        }
        self.minTemperatureLabel.text = "\(weather.minTemperature)"
        self.maxTemperatureLabel.text = "\(weather.maxTemperature)"
    }
    
    func setWeatherError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler:  nil))
        self.present(alert, animated: true, completion: nil)
    }
}
