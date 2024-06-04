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
    var weather: Weather? {
        didSet {
            if isViewLoaded, let weather = weather {
                updateUI(with: weather)
            }
        }
    }
    var areaTitle: String {
        return "\(area)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.hidesWhenStopped = true
        if let weather = weather {
            updateUI(with: weather)
        }
        if let weatherDate = weatherManager.weatherDate {
               self.navigationController?.navigationBar.prefersLargeTitles = false
               self.navigationItem.title = weatherDate.areaTitle
        }
    }
    
    @IBAction func reloadBtn(_ sender: Any) {
        weatherResult()
    }
    
    func weatherResult() {
        indicator.startAnimating()
        weatherManager.updateWeather { [weak self] result in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                switch result {
                case .success(let weather):
                    self?.updateUI(with: weather)
                case .failure(let error):
                    self?.showError(error: error)
                }
            }
        }
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateUI(with weather: Weather) {
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
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler:  nil))
        self.present(alert, animated: true, completion: nil)
    }
}
