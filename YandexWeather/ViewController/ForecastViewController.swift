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
    var token: NotificationToken!
    let myRefrechControll:UIRefreshControl = {
        let refrechControll = UIRefreshControl()
        refrechControll.addTarget(self, action: #selector(refrech(sender:)), for: .valueChanged)
        return refrechControll
    }()
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Прогноз на неделю"
        self.items = self.realm.objects(WeatherDataRealm.self)
        token = realm.observe { change,realm in
            switch change {
            case .didChange:
                print("Update Data in Realm")
            default: ()
            }
        }
        table.refreshControl = myRefrechControll
        table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.reuseID)
        table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       table.reloadData()
    }
    
    @objc private func refrech(sender: UIRefreshControl) {
        table.reloadData()
        sender.endRefreshing()
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
        return aState.forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseID, for: indexPath)
        as! TableViewCell
        guard let item = items.last else {return cell}
        let myCellView = CellViewModel(date: item.forecast[indexPath.row], temp: item.temperatureForDays[indexPath.row], icon: item.iconForDays[indexPath.row])
        cell.setup(with: myCellView )
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(TableViewCell.cellHeight)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueForCollectionView", sender: indexPath.row)
    }
    
}
