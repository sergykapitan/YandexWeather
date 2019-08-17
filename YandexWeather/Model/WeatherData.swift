//
//  WeatherData.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 09/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


class WeatherDataRealm: Object {
    
    @objc dynamic var ID = UUID().uuidString
    @objc dynamic var temperature: Int = 0
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longtitude: Double = 0
    @objc dynamic var city: String = "SPB"       //временной пояс
    @objc dynamic var condition: String = "clear"
    @objc dynamic var date: String = "2019-08-17"
    var forecast = List<String>()
    var temperatureForDays = List<Int>()
    var conditionsForDays = List<String>()
    var iconForDays = List<String>()
    var hoursForDays = List<Hours>()
   
    override static func primaryKey() -> String? {
        return "ID"
    }
    
}
class Hours: Object{
      var temp = List<Int>()
      var icon = List<String>()
      var hour = List<String>()
}

