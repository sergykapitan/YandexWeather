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
    var hoursForDays = List<Hours>()
   
    override static func primaryKey() -> String? {
        return "ID"
    }
    
}
class Hours: Object{
    @objc dynamic var hour0: Int = 0
    @objc dynamic var hour1: Int = 0
    @objc dynamic var hour2: Int = 0
    @objc dynamic var hour3: Int = 0
    @objc dynamic var hour4: Int = 0
    @objc dynamic var hour5: Int = 0
    @objc dynamic var hour6: Int = 0
    @objc dynamic var hour7: Int = 0
    @objc dynamic var hour8: Int = 0
    @objc dynamic var hour9: Int = 0
    @objc dynamic  var hour10: Int = 0
    @objc dynamic var hour11: Int = 0
    @objc dynamic  var hour12: Int = 0
    @objc dynamic var hour13: Int = 0
    @objc dynamic var hour14: Int = 0
    @objc dynamic  var hour15: Int = 0
    @objc dynamic var hour16: Int = 0
    @objc dynamic  var hour17: Int = 0
    @objc dynamic  var hour18: Int = 0
    @objc dynamic  var hour19: Int = 0
    @objc dynamic  var hour20: Int = 0
    @objc dynamic  var hour21: Int = 0
    @objc dynamic  var hour22: Int = 0
    @objc dynamic var hour23: Int = 0
    
    
}
struct Temp  {
    var tempo = [Int]()
}

//extension WeatherDataRealm {
//    func getStr() -> [Int] {
//        var outerArray =  [Int] ()
//        for loc in hoursForDays{
//            for i in loc {
//            outerArray.append(i)
//            }
//        }
//        
//        return outerArray
//    }
//        
//    }
//}
