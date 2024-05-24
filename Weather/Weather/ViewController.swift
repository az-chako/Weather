//
//  ViewController.swift
//  Weather
//
//  Created by spark-03 on 2024/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var weatherImg: UIImageView!
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
    
    func setWeatherImages(type: String) {
        switch type {
        case "sunny":
            weatherImg.image = UIImage(named: "sunny")?.withRenderingMode(.alwaysTemplate)
            weatherImg.tintColor = .red
        case "cloudy":
            weatherImg.image = UIImage(named: "cloudy")?.withRenderingMode(.alwaysTemplate)
            weatherImg.tintColor = .gray
        case "rainy":
            weatherImg.image = UIImage(named: "rainy")?.withRenderingMode(.alwaysTemplate)
            weatherImg.tintColor = .blue
        default:
            break
        }
    }
}
