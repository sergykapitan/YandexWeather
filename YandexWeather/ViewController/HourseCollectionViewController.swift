//
//  HourseCollectionViewController.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 13/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit
import RealmSwift
import SVGKit

private let reuseIdentifier = "Cell"

class HourseCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let baseURLImage = "https://yastatic.net/weather/i/icons/blueye/color/svg/"
    var items: Results<WeatherDataRealm>!
    let realm = try! Realm()
    var index = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Прогноз по Часам"
        self.items = self.realm.objects(WeatherDataRealm.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let temp = items.last
        return temp?.hoursForDays[index].temp.count ?? 24
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      //  let myViewModel = items.last
       // print(myViewModel?.hoursForDays[index])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        as! ImageCell
        guard let hour = items.last else {return cell}
        let tem = hour.hoursForDays[index]
        guard let intHours = UInt(tem.hour[indexPath.row]) else {return cell}
        cell.timeLabel.text = hoursCountUniversal(count: intHours)
        //formatHors(hour: "\(tem.hour[indexPath.row])")
        cell.temperatureForHoursLabel.text = "Темп:\(tem.temp[indexPath.row])° C"
        let imageName = tem.icon[indexPath.row]  
        guard let url = URL(string: baseURLImage + imageName + ".svg") else {return cell}
        let namSvgImgVar: SVGKImage = SVGKImage(contentsOf: url)
        cell.imageIcon.image = namSvgImgVar.uiImage
    
        return cell
    }

    
}
extension HourseCollectionViewController {
    // change ending [час часа часов]
    private func hoursCountUniversal(count: UInt) -> String{
        let formatHours: String = NSLocalizedString("HoursCount", comment: "found in Localized.stringsdict")
        let resultString : String = String.localizedStringWithFormat(formatHours, count)
        return resultString
    }
}
