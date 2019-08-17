//
//  ImageCell.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 13/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import Foundation
import UIKit



class ImageCell: UICollectionViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var temperatureForHoursLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        imageIcon.layer.cornerRadius = 5
    }
    
    
}

