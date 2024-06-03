//
//  TableListViewController.swift
//  Weather
//
//  Created by spark-03 on 2024/06/03.
//

import UIKit

class TableListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var AreaResponse: [AreaResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        weatherResult()
    }
    
    func weatherResult() {
        let weatherListManager = WeatherList()
        weatherListManager.areaWeather { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.AreaResponse = list
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(error: error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AreaResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        let weather = AreaResponse[indexPath.row]
        cell.textLabel?.text = "\(weather.info.weatherImage): \(weather.info.minTemperature) - \(weather.info.maxTemperature)"
        return cell
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
