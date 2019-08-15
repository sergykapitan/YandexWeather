//
//  TableViewCell.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 12/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let reuseID = "WeatherCell"
    
    
    @IBOutlet var cellWraperView: UIView!
    @IBOutlet var weatherIconImage: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellWraperView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            cellWraperView.backgroundColor = .white
        }
        
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        if highlighted {
            cellWraperView.backgroundColor = .white
        }
    }
    
    
    
    
    
    
}
