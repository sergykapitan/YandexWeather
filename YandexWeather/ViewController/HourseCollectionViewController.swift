//
//  HourseCollectionViewController.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 13/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class HourseCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var items: Results<WeatherDataRealm>!
    let realm = try! Realm()
    var index = 0
    
    var images = [UIImage?] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Прогноз по Часам"
        self.items = self.realm.objects(WeatherDataRealm.self)
       
        
        for _ in 0...24 {
            images.append(UIImage(named: "clear"))
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        as! ImageCell
        guard let hour = items.last else {return cell}
       // print(items.last)
      //  let array = Array(hour.hoursForDays)
        cell.imageIcon.image = images[indexPath.row]
      //  var tem = hour.hoursForDays[index]
      //  let a = "hour" + "\([indexPath.row])"
       //  print(tem)
      //  let arr = Array(tem)
      //  print(arr)
      //  cell.temperatureForHoursLabel.text = tem[indexPath.row]
      //  print(item.temperatureForHours[indexPath.row])
      //  cell.temperatureForHoursLabel.text = "\(item.temperatureForHours[indexPath.row])° C"
    
        return cell
    }

    
}
