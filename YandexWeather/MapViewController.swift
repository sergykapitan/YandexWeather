//
//  ViewController.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 09/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
    //MARK: - Property
    private let locationManager = CLLocationManager()
    
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

    //MARK: - DatatoMapPresenter
extension MapViewController {
    
    func getWeatherDataPresenter(parameters: [String : String]) {
        MapPresenter.shared.getWeatherDataPresenter(parameters: parameters) { (weatherData) in
            self.updateUI(with: weatherData)
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
      
        let params: [String : String] = [
            "lat": String(latitude),
            "lon": String(longitude),
            "lang": "ru",
            "limit": "7",
            "hours": "true",
            "extra": "false"
            ]
        getWeatherDataPresenter(parameters: params)
        hideError()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription)")
        showError(msg: "Location Unavailable")
    }
}
