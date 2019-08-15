//
//  ForecastViewController.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 11/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit
import RealmSwift
import SVGKit

class ForecastViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    let baseURLImage = "https://yastatic.net/weather/i/icons/blueye/color/svg/"
   
    let realm = try! Realm()
    var items: Results<WeatherDataRealm>!
    var token: NotificationToken!
    let myRefrechControll:UIRefreshControl = {
        let refrechControll = UIRefreshControl()
        refrechControll.addTarget(self, action: #selector(refrech(sender:)), for: .valueChanged)
        return refrechControll
        
    }()
   
  
    let cellId = "Cell"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Прогноз на неделю"
        self.items = self.realm.objects(WeatherDataRealm.self)
        token = realm.observe { change,realm in
            switch change {
            case .didChange:
              print("Обновленны данные")
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

extension ForecastViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let aState = items.last else {return items.count}
        return aState.forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseID, for: indexPath)
        as! TableViewCell
        guard let item = items.last else {return cell}
        let date = formatDate(dateStr: item.forecast[indexPath.row])
        cell.dateLabel.text? = "Прогноз на: " + "\(date)"
        cell.temperatureLabel.text = "\(item.temperatureForDays[indexPath.row])° C"
        let imageName = item.iconForDays[indexPath.row]
        guard let url = URL(string: baseURLImage + imageName + ".svg") else {return cell}
        let namSvgImgVar: SVGKImage = SVGKImage(contentsOf: url)
        cell.weatherIconImage.image = namSvgImgVar.uiImage
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueForCollectionView", sender: indexPath.row)
    }
    
}
