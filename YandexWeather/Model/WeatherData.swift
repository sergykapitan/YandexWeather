//
//  WeatherData.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 09/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import Foundation

struct WeatherData {
    
    
//        let info: Info
//        let fact: Fact
//        let days: [Day]
//        
//        init(from decoder: Decoder) throws {
//            let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
//            info = try valueContainer.decode(Info.self, forKey: CodingKeys.info)
//            fact = try valueContainer.decode(Fact.self, forKey: CodingKeys.fact)
//            days = try valueContainer.decode([Day].self, forKey: CodingKeys.days)
//        }
//        
//        enum CodingKeys: String, CodingKey {
//            case info
//            case fact
//            case days = "forecasts"
//        }
//    
//    
    
    
    
    
    
    
    let temperature: Int
    let latitude: Double
    let longtitude: Double
    let city: String
    let condition: Int
}
struct Info: Codable {                        // Информация о местности
    let shirota: Double
    let dolgota: Double
    let barometerUsually: Float
    let infoCity: City
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        shirota = try valueContainer.decode(Double.self, forKey: CodingKeys.shirota)
        dolgota = try valueContainer.decode(Double.self, forKey: CodingKeys.dolgota)
        barometerUsually = try valueContainer.decode(Float.self, forKey: CodingKeys.barometerUsually)
        infoCity = try valueContainer.decode(City.self, forKey: CodingKeys.infoCity)
    }
    
    enum CodingKeys: String, CodingKey {
        case shirota = "lat"
        case dolgota = "lon"
        case barometerUsually = "def_pressure_mm"
        case infoCity = "tzinfo"
    }
}
struct City: Codable {                        // Информация о городе
    let offset: Int
    let name: String
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        offset = try valueContainer.decode(Int.self, forKey: CodingKeys.offset)
        name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
    }
    
    enum CodingKeys: String, CodingKey {
        case offset
        case name
    }
}
struct Fact: Codable {                        // Погодные данные в данный момент
    let temp: Int
    let feelsLike: Int
    let icon: String
    // icon
    let condition: String
    // Расписать погодные явления
    let windSpeed: Double
    let windGust: Double
    let windDir: String
    // Расписать направление ветра
    let pressureMm: Int
    let humidity: Int
    let dayTime: String
    // Расписать время суток
    let season: String
    // Расписать времена года
    let precType: Int
    // Расписать возможные осадки
    let precStrength: Double
    // Расписать силу осадков
    let cloudness: Double
    // Расписать облачность
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        temp = try valueContainer.decode(Int.self, forKey: CodingKeys.temp)
        feelsLike = try valueContainer.decode(Int.self, forKey: CodingKeys.feelsLike)
        icon = try valueContainer.decode(String.self, forKey: CodingKeys.icon)
        condition = try valueContainer.decode(String.self, forKey: CodingKeys.condition)
        windSpeed = try valueContainer.decode(Double.self, forKey: CodingKeys.windSpeed)
        windGust = try valueContainer.decode(Double.self, forKey: CodingKeys.windGust)
        windDir = try valueContainer.decode(String.self, forKey: CodingKeys.windDir)
        pressureMm = try valueContainer.decode(Int.self, forKey: CodingKeys.pressureMm)
        humidity = try valueContainer.decode(Int.self, forKey: CodingKeys.humidity)
        dayTime = try valueContainer.decode(String.self, forKey: CodingKeys.dayTime)
        precType = try valueContainer.decode(Int.self, forKey: CodingKeys.precType)
        precStrength = try valueContainer.decode(Double.self, forKey: CodingKeys.precStrength)
        cloudness = try valueContainer.decode(Double.self, forKey: CodingKeys.cloudness)
        season = try valueContainer.decode(String.self, forKey: CodingKeys.season)
    }
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case icon
        case condition
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case humidity
        case dayTime = "daytime"
        case season
        case precType = "prec_type"
        case precStrength = "prec_strength"
        case cloudness
    }
}
struct Day: Codable {                          // Прогноз погоды на день (почему-то независимо от параметра запроса выгружает все 7 дней)
    let date: String
    let week: Int
    let sunrise: String
    let sunset: String
    let moonText: String
    let parts: Part                        // По документации данных может не быть
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        date = try valueContainer.decode(String.self, forKey: CodingKeys.date)
        week = try valueContainer.decode(Int.self, forKey: CodingKeys.week)
        sunset = try valueContainer.decode(String.self, forKey: CodingKeys.sunset)
        sunrise = try valueContainer.decode(String.self, forKey: CodingKeys.sunrise)
        moonText = try valueContainer.decode(String.self, forKey: CodingKeys.moonText)
        parts = try valueContainer.decode(Part.self, forKey: CodingKeys.parts)
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case week
        case sunset
        case sunrise
        case moonText = "moon_text"
        case parts
    }
}

struct Part: Codable {                           // Прогноз на часть суток (ночь, утро, день, вечер)
    var night: PartOfDay                         // ВАЖНО!! по документации данных может не быть
    var morning: PartOfDay
    var day: PartOfDay
    var evening: PartOfDay
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        night = try valueContainer.decode(PartOfDay.self, forKey: CodingKeys.night)
        morning = try valueContainer.decode(PartOfDay.self, forKey: CodingKeys.morning)
        day = try valueContainer.decode(PartOfDay.self, forKey: CodingKeys.day)
        evening = try valueContainer.decode(PartOfDay.self, forKey: CodingKeys.evening)
    }
    
    enum CodingKeys: String, CodingKey {
        case night
        case morning
        case day
        case evening
    }
}

struct PartOfDay: Codable {
    let tempMin: Int
    let tempMax: Int
    let tempAvg: Int
    let feelsLike: Int
    let icon: String
    // icon
    let condition: String
    // Расписать погодные явления
    let windSpeed: Double
    let windGust: Double
    let windDir: String
    // Расписать направление ветра
    let pressureMm: Int
    let humidity: Int
    let dayTime: String
    // Расписать время суток
    let polar: Bool
    let precMm: Double
    let precPeriod: Int
    let precType: Int
    // Расписать возможные осадки
    let precStrength: Double
    // Расписать силу осадков
    let cloudness: Double
    // Расписать облачность
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        tempMin = try valueContainer.decode(Int.self, forKey: CodingKeys.tempMin)
        tempMax = try valueContainer.decode(Int.self, forKey: CodingKeys.tempMax)
        tempAvg = try valueContainer.decode(Int.self, forKey: CodingKeys.tempAvg)
        feelsLike = try valueContainer.decode(Int.self, forKey: CodingKeys.feelsLike)
        icon = try valueContainer.decode(String.self, forKey: CodingKeys.icon)
        condition = try valueContainer.decode(String.self, forKey: CodingKeys.condition)
        windSpeed = try valueContainer.decode(Double.self, forKey: CodingKeys.windSpeed)
        windGust = try valueContainer.decode(Double.self, forKey: CodingKeys.windGust)
        windDir = try valueContainer.decode(String.self, forKey: CodingKeys.windDir)
        pressureMm = try valueContainer.decode(Int.self, forKey: CodingKeys.pressureMm)
        humidity = try valueContainer.decode(Int.self, forKey: CodingKeys.humidity)
        dayTime = try valueContainer.decode(String.self, forKey: CodingKeys.dayTime)
        polar = try valueContainer.decode(Bool.self, forKey: CodingKeys.polar)
        precMm = try valueContainer.decode(Double.self, forKey: CodingKeys.precMm)
        precPeriod = try valueContainer.decode(Int.self, forKey: CodingKeys.precPeriod)
        precType = try valueContainer.decode(Int.self, forKey: CodingKeys.precType)
        precStrength = try valueContainer.decode(Double.self, forKey: CodingKeys.precStrength)
        cloudness = try valueContainer.decode(Double.self, forKey: CodingKeys.cloudness)
    }
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case tempAvg = "temp_avg"
        case feelsLike = "feels_like"
        case icon
        case condition
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case humidity
        case dayTime = "daytime"
        case polar
        case precMm = "prec_mm"
        case precPeriod = "prec_period"
        case precType = "prec_type"
        case precStrength = "prec_strength"
        case cloudness
    }
}







//MARK: - Get icon for condition
/***************************************************************/

extension WeatherData {
    func getIcon() -> String {
        switch (condition) {
           
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
    }
}
