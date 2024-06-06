//
//  CollectionViewController.swift
//  Weather
//
//  Created by spark-03 on 2024/06/06.
//

import UIKit

class CollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var CollectionView: UICollectionView!
    var areaResponse: [AreaResponse] = []
    let refreshControl = UIRefreshControl()
    
    // 英語の都市名から日本語の都市名へのマッピング辞書
    let areaNamesInJapanese: [String: String] = [
        "Sapporo": "札幌",
        "Sendai": "仙台",
        "Niigata": "新潟",
        "Kanazawa": "金沢",
        "Tokyo": "東京",
        "Nagoya": "名古屋",
        "Osaka": "大阪",
        "Hiroshima": "広島",
        "Kochi": "高知",
        "Fukuoka": "福岡",
        "Kagoshima": "鹿児島",
        "Naha": "那覇"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.dataSource = self
        CollectionView.delegate = self
        setupRefreshControl()
        weatherResult()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        CollectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        weatherResult()
    }
    
    func weatherResult() {
        let weatherListManager = WeatherList()
        weatherListManager.areaWeather { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let list):
                    self.areaResponse = list.map { response in
                        var newResponse = response
                        if let japaneseName = self.areaNamesInJapanese[response.area] {
                            newResponse.area = japaneseName
                        }
                        return newResponse
                    }
                    self.CollectionView.reloadData()
                case .failure(let error):
                    self.showError(error: error)
                }
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // numberOfItemsInSectionメソッドの修正
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areaResponse.count
    }
    
    // cellForItemAtメソッドの修正
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let weather = areaResponse[indexPath.row]
        
        // セルに地域名を設定
        cell.configure(with: weather.area)
        
        // セルに画像を設定し、タップジェスチャーを追加
        cell.imageView.image = UIImage(named: weather.info.weatherImage)?.withRenderingMode(.alwaysTemplate)
        
        // タップジェスチャーの追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.addGestureRecognizer(tapGesture)
        cell.imageView.tag = indexPath.row // タップされた画像のindexをタグとして設定
        
        switch weather.info.weatherImage {
        case "sunny": cell.imageView.tintColor = .red
        case "cloudy": cell.imageView.tintColor = .gray
        case "rainy": cell.imageView.tintColor = .blue
        default:
            break
        }
        return cell
    }
    // タップジェスチャーのハンドラメソッド
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            let selectedIndex = imageView.tag
            performSegue(withIdentifier: "showDetail", sender: areaResponse[selectedIndex])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let detailVC = segue.destination as? ViewController,
           let selectedAreaResponse = sender as? AreaResponse {
            detailVC.weather = selectedAreaResponse.info
            detailVC.areaTitle = selectedAreaResponse.area
        }
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "エラー", message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.weatherResult()
        }))
        self.present(alert, animated: true, completion: nil)
        
        // 1列に3つのアイテムを表示するためのサイズを設定
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let padding: CGFloat = 10
            let collectionViewSize = collectionView.frame.size.width - (padding * 2) // 両側のpaddingを考慮
            let itemSize = collectionViewSize / 3 // 1列に3つ表示するために3で割る
            return CGSize(width: itemSize, height: itemSize)
        }
    }
}
