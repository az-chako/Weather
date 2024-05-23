//
//  ViewController.swift
//  Weather
//
//  Created by spark-03 on 2024/05/22.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {
    @IBOutlet weak var weatherImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func reloadBtn(_ sender: Any) {
        setWeatherType()
    }
    
    func setWeatherType() {
        let weather = YumemiWeather.fetchWeatherCondition()
        switch weather {
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

