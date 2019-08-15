//
//  ViewController.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 09/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import RealmSwift

class MapViewController: UIViewController {
    
    //MARK: - Property
    let realm = try! Realm() //Доступ к хранилищу
    private let locationManager = CLLocationManager()
    private let WEATHER_URL = "https://api.weather.yandex.ru/v1/forecast"
    private  let head:[String:String] = ["X-Yandex-API-Key": "9a4dd815-d16d-46a5-bc87-0801a556b444"]
   
    
    
    //MARK: - Outlets
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var warningLabel: UILabel!
    
    //MARK: - Action
    
    @IBAction func forecastButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SegueTabView", sender: nil)
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueTabView" {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
         title = "Карта"
      
         setupLocationManager()
       //  print(Realm.Configuration.defaultConfiguration.fileURL!)// путь к базе данных
    }
    


}
    //MARK: - Networking
extension MapViewController {
    private func getWeatherData(url: String, parameters: [String : String]) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request(url, method: .get, parameters: parameters, headers: head).responseJSON { response in
            if response.result.isSuccess {
                print("isSucces")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error \(String(describing: response.result.error?.localizedDescription))")
                self.showError(msg: "Connection Issues")
            }
        }
    }
}
    //MARK: - UI Updates
extension MapViewController {
    
    private func updateUI(with data: WeatherDataRealm ) {
        
        let markerView = MarkerView(frame: CGRect(x: 0, y: 0, width: 50, height: 70),
                                    picture: data.condition, 
                                    temperature: String(data.temperature))
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
                                                 latitude: data.latitude,
                                                 longitude: data.longtitude)
        marker.icon = markerView.asImage()
        marker.opacity = 0.7
        marker.title = data.city
        marker.map = mapView
        
        hideError()
    }

    private func showError(msg: String) {
        self.warningLabel.text = msg
        self.warningLabel.isHidden = false
    }
    
    private func hideError() {
        self.warningLabel.isHidden = true
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
      
    }
}


//MARK: - JSON Parsing

extension MapViewController {
    
    private func updateWeatherData(json: JSON) {
        let list = json
   
        guard list.count > 0 else {
            showError(msg: "Weather Unavailable")
            return }
        print(list["forecasts"][0]["hours"].arrayValue.map({$0["icon"].stringValue}))
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
        
        updateUI(with: weatherDataRealm)
        
    }
}

//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude,
                                                  longitude: longitude,
                                                  zoom: 12.0)
       // locationManager.requestAlwaysAuthorization()
        //locationManager.stopUpdatingLocation()
        
        let params: [String : String] = [
            "lat": String(latitude),
            "lon": String(longitude),
            "lang": "ru",
            "limit": "1",
            "hours": "true",
            "extra": "false"
            ]
        
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
        hideError()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription)")
        showError(msg: "Location Unavailable")
    }
}
