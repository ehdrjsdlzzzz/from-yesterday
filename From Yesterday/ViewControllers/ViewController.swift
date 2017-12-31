//
//  ViewController.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 28..
//  Copyright © 2017년 이동건. All rights reserved.

import UIKit
import Alamofire
import CoreLocation
import SVProgressHUD

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var minMaxLabel: UILabel!
    
    var currentLocation: CLLocation!
    var currentWeather: CurrentWeather?
    var forcastWeather: [ForecastWeather] = []
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "From Yesterday"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        
        setCurrentDate()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
}

// MARK: Target-Action Method

extension ViewController {
    @objc func refresh(){
        locationAuthStatus()
    }
}

// MARK: Additional Method

extension ViewController {
    func setCurrentDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate: String = dateFormatter.string(from: date)
        let dateArray = stringDate.split(separator: "-")
        self.dateLabel.text = "\(dateArray[2])일"
    }
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.shared.lat = currentLocation.coordinate.latitude
            Location.shared.lon = currentLocation.coordinate.longitude
            
            downloadCurrentWeather {
//                print(Location.shared.lat)
//                print(Location.shared.lon)
                self.areaLabel.text = self.currentWeather?.city
                self.statusLabel.text = self.currentWeather?.status
                self.currentLabel.text = "\(self.currentWeather!.current)"
                self.minMaxLabel.text = "\(self.currentWeather!.max)/\(self.currentWeather!.min)"
                
                self.downloadForecastWeather {
                    
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
}

// MARK: Download Weather

extension ViewController {
    func downloadCurrentWeather(completed: @escaping ()->() ){
        Alamofire.request(CURRENT_WEATHER_URL, headers: HTTP_HEADER).responseJSON { (response) in

            guard let result = response.result.value as? [String:Any] else {return}
            guard let weather = result["weather"] as? [String: Any] else {return}
            guard let hourlyArr = weather["hourly"] as? [Any] else {return}
            if hourlyArr.count == 0 {
                return
            }
            guard let hourly = hourlyArr[0] as? [String: Any] else {return}
            guard let grid = hourly["grid"] as? [String: String] else {return}
            guard let sky = hourly["sky"] as? [String: String] else {return}
            guard let temperature = hourly["temperature"] as? [String:String] else {return}
            
            guard let city = grid["city"] else {return}
            guard let status = sky["name"] else {return}
            guard let tc = temperature["tc"] else {return}
            guard let tmax = temperature["tmax"] else {return}
            guard let tmin = temperature["tmin"] else {return}

            
            guard let humiditiy = hourly["humidity"] as? String else {return}
            
            self.currentWeather = CurrentWeather(city: city, status: status, current: tc, humidity: humiditiy, min: tmin, max: tmax)
            
            completed()
        }
    }
    
    func downloadForecastWeather(completed: @escaping ()->()){
        Alamofire.request(FORECAST_WEATHER_URL).responseJSON { (response) in
            guard let result = response.result.value as? [String:Any] else {return}
            print(result)
        }
    }
    
}


