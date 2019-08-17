//
//  HourseCollectionViewController.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 13/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit
import RealmSwift


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
        return ImageCell.cellHeight
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let temp = items.last else {return 24}
        return temp.hoursForDays[index].temp.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath)
        as! ImageCell
        guard let hour = items.last else {return cell}
        let tem = hour.hoursForDays[index]
        let myHoursViewModel = HoursViewModel(hour: tem.hour[indexPath.row], temp: tem.temp[indexPath.row], icon: tem.icon[indexPath.row])
        cell.setup(with: myHoursViewModel)
        return cell
    }
}

