//
//  CollectionViewCell.swift
//  Weather
//
//  Created by spark-03 on 2024/06/06.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var areaLabel: UILabel!
    
    func configure(with areaName: String) {
            areaLabel.text = areaName
        }
}
