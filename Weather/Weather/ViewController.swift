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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        indicator.hidesWhenStopped = true
    }
    
    @IBAction func reloadBtn(_ sender: Any) {
        indicator.startAnimating()
        weatherManager.updateWeather()
    }
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension ViewController: YumemiDelegate {
    
    func setWeather(weather: Weather) {
        DispatchQueue.main.async {
            self.weatherImg.image = UIImage(named: weather.weatherImage)?.withRenderingMode(.alwaysTemplate)
            switch weather.weatherImage {
            case "sunny":
                self.weatherImg.tintColor = .red
            case "cloudy":
                self.weatherImg.tintColor = .gray
            case "rainy":
                self.weatherImg.tintColor = .blue
            default:
                break
            }
            self.minTemperatureLabel.text = "\(weather.minTemperature)"
            self.maxTemperatureLabel.text = "\(weather.maxTemperature)"
            self.indicator.stopAnimating()
        }
    }
    
    func setWeatherError(error: Error) {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler:  nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
