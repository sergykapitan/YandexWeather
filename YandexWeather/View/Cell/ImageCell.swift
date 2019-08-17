//
//  ImageCell.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 13/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import Foundation
import UIKit
import SVGKit


class ImageCell: UICollectionViewCell {

    let baseURLImage = "https://yastatic.net/weather/i/icons/blueye/color/svg/"
    static let reuseID = "HoursCell"
    static let cellHeight: CGSize = CGSize(width: 100, height: 100)
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var temperatureForHoursLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        imageIcon.layer.cornerRadius = 5
    }
    
    func setup(with viewModel: HoursViewModel) {
        
        guard let intHours = UInt(viewModel.hour) else { return }
        timeLabel.text = hoursCountUniversal(count: intHours)
        temperatureForHoursLabel.text = "Темп:\(viewModel.temp)° C"
        guard let url = URL(string: baseURLImage + viewModel.icon + ".svg") else {return}
        let namSvgImgVar: SVGKImage = SVGKImage(contentsOf: url)
        imageIcon.image = namSvgImgVar.uiImage
       
        
    }
    
}
extension ImageCell {
    // change ending [час часа часов]
    private func hoursCountUniversal(count: UInt) -> String{
        let formatHours: String = NSLocalizedString("HoursCount", comment: "found in Localized.stringsdict")
        let resultString : String = String.localizedStringWithFormat(formatHours, count)
        return resultString
    }
}
