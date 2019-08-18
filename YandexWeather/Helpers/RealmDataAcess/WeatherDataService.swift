//
//  WeatherDataService.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 17/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class WeatherDataServise {
    
    private init() {}
    static let shared = WeatherDataServise()
    let realm = try! Realm()
    
    func updateWeatherData(json: JSON, completion: @escaping(WeatherDataRealm) -> ()) {
        let list = json
        guard list.count > 0 else {
            print("Weather Unavailable")
            return }
        let weatherDataRealm = WeatherDataRealm(value: [
                                    "My-Primary-Key",
                                    list["fact"]["temp"].int!,
                                    list["info"]["lat"].double!,
                                    list["info"]["lon"].double!,
                                    list["info"]["tzinfo"]["name"].stringValue,
                                    list["fact"]["condition"].stringValue,
                                    list["forecasts"][0]["date"].stringValue,
                                    list["forecasts"].arrayValue.map{$0["date"].stringValue},
                                    list["forecasts"].arrayValue.map{$0["parts"]["day"]["temp_avg"].intValue},
                                    list["forecasts"].arrayValue.map{$0["parts"]["day"]["condition"].stringValue},
                                    list["forecasts"].arrayValue.map{$0["parts"]["day"]["icon"].stringValue}
                                    ])
        for i in 0..<7 {
            let hours = Hours()
            for n in list["forecasts"][0]["hours"].arrayValue.map({$0["hour"].stringValue}) {
                hours.hour.append(n)
            }
            for j in list["forecasts"][i]["hours"].arrayValue.map({$0["icon"].stringValue}) {
                hours.icon.append(j)
            }
            for y in list["forecasts"][i]["hours"].arrayValue.map({$0["temp"].intValue}) {
                hours.temp.append(y)
            }
            weatherDataRealm.hoursForDays.append(hours)
        }
        
        //запись в базу данных
        try! self.realm.write {
            self.realm.add(weatherDataRealm,update: .modified)
        }
        completion(weatherDataRealm)
    }
}
