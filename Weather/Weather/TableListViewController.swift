//
//  TableListViewController.swift
//  Weather
//
//  Created by spark-03 on 2024/06/03.
//

import UIKit

class TableListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var areaResponse: [AreaResponse] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupRefreshControl()
        weatherResult()
    }
    
    func setupRefreshControl() {
            refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
    
    @objc private func refreshWeatherData(_ sender:Any) {
        weatherResult()
    }
    
    func weatherResult() {
        let weatherListManager = WeatherList()
        weatherListManager.areaWeather { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.areaResponse = list
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(error: error)
                }
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let weather = areaResponse[indexPath.row]
        cell.textLabel?.text = weather.area
        cell.detailTextLabel?.text = "最低気温:\(weather.info.minTemperature)℃  最高気温: \(weather.info.maxTemperature)℃"
        let weatherImageView = cell.imageView!
        weatherImageView.image = UIImage(named: weather.info.weatherImage)?.withRenderingMode(.alwaysTemplate)
        
        switch weather.info.weatherImage {
        case "sunny": weatherImageView.tintColor = .red
        case "cloudy": weatherImageView.tintColor = .gray
        case "rainy": weatherImageView.tintColor = .blue
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedWeather = areaResponse[indexPath.row].info
                let selectedArea = areaResponse[indexPath.row].area
                if let detailVC = segue.destination as? ViewController {
                    detailVC.weather = selectedWeather
                    detailVC.areaTitle = selectedArea
                }
            }
        }
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.weatherResult()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
