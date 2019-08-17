//
//  TableViewCell.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 12/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit
import RealmSwift
import SVGKit


class TableViewCell: UITableViewCell {
    
    static let reuseID = "WeatherCell"
    static var cellHeight = 115
    let baseURLImage = "https://yastatic.net/weather/i/icons/blueye/color/svg/"
    
    
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
    
    func setup(with viewModel: CellViewModel) {
        
        guard let url = URL(string: baseURLImage + viewModel.icon + ".svg") else {return }

        let date = formatDate(dateStr: viewModel.date)
        let image = SVGKImage(contentsOf: url)
        
        dateLabel.text = "Прогноз на: " + "\(date)"
        temperatureLabel.text = "\(viewModel.temp)° C"
        weatherIconImage.image = image?.uiImage
        
    }
}
extension TableViewCell {
    
    func formatDate(dateStr: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMMM"
        dateFormatterPrint.locale = Locale(identifier: "ru_RU")
        
        let date: NSDate? = dateFormatterGet.date(from: dateStr) as NSDate?
        return dateFormatterPrint.string(from: date! as Date)
    }
}
