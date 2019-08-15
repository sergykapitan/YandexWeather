//
//  ForecastViewController.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 11/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit
import RealmSwift

class ForecastViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
   
    let realm = try! Realm()
    var items: Results<WeatherDataRealm>!
  
  
    let cellId = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Прогноз на неделю"
        self.items = self.realm.objects(WeatherDataRealm.self)
        table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.reuseID)
        table.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        table.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
       table.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? HourseCollectionViewController {
            viewController.index = sender as? Int ?? 0
        }
    }

}

extension ForecastViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let aState = items.last else {return items.count}
        print(aState.forecast.count)
        return aState.forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseID, for: indexPath)
        as! TableViewCell
        guard let item = items.last else {return cell}
        cell.dateLabel.text = item.forecast[indexPath.row]
        cell.temperatureLabel.text = "\(item.temperatureForDays[indexPath.row])° C"
        let imageName = item.conditionsForDays[indexPath.row]
        cell.weatherIconImage.image = UIImage(named: imageName)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select Row\(indexPath.row)")
        performSegue(withIdentifier: "SegueForCollectionView", sender: indexPath.row)
    }
    
}
