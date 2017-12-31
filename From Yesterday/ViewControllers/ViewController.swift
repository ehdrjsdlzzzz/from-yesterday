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
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var currentLocation: CLLocation!
    
    var country:String?
    var city:String?
    
    var forecastWeather: [ForecastWeather] = []
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "From Yesterday"
        
        statusLabel.text = nil
        areaLabel.text = nil
        dateLabel.text = nil
        currentLabel.text = nil
    

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
        var dateArray = stringDate.split(separator: "-")
        self.dateLabel.text = "\(dateArray[2])일"
    }
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.shared.lat = currentLocation.coordinate.latitude
            Location.shared.lon = currentLocation.coordinate.longitude
            
            downloadCurrentWeather {
                print(Location.shared.lat)
                print(Location.shared.lon)
                let currentWeather = self.forecastWeather[0]
                self.areaLabel.text = "\(self.country!) \(self.city!)"
                self.statusLabel.text = currentWeather.status
                self.currentLabel.text = "\(currentWeather.tc)\u{00B0}C"
                let weatherImage = Weather(rawValue:currentWeather.code)?.image()
                print(weatherImage!)
                self.weatherIcon.image = UIImage(named: weatherImage!)
                self.forecastWeather.forEach({
                    print("\($0.day)일 \($0.tc)도 최대\($0.tmax)/최소\($0.tmin) 습도: \($0.humidity) 코드\($0.code)")
                SVProgressHUD.dismiss()
                })
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
        SVProgressHUD.show()
        Alamofire.request(CURRENT_WEATHER_URL, headers: HTTP_HEADER).responseJSON { (response) in
            guard let value = response.result.value as? [String:Any] else {return}
            guard let result = value["result"] as? [String:Any] else {return}
            guard let code = result["code"] as? Int else {return}
            if code != 9200 { // Not Ok
                return
            }
            guard let gweather = value["gweather"] as? [String:Any] else {return}
            guard let forecastDays = gweather["forecastDays"] as? [[String:Any]] else {return}
            guard let location = forecastDays[0]["location"] as? [String:String] else {return}
            guard let country = location["country"] else {return}
            guard let city = location["city"] else {return}
            
            self.country = country
            self.city = city
            
            guard let forecast = forecastDays[0]["forecast"] as? [[String:Any]] else {return}
            
            for i in 0...7 {
                let day = forecast[i]
                guard let timeRaw = day["time"] as? String else {return}
                guard let skyRaw = day["sky"] as? [String:String] else {return}
                guard let skyDesc = skyRaw["name"] else {return}
                guard let code = skyRaw["code"] else {return}
                guard let tempRaw = day["temperature"] as? [String:String] else {return}
                guard let tc = tempRaw["tc"] else {return}
                guard let tmax = tempRaw["tmax"] else {return}
                guard let tmin = tempRaw["tmin"] else {return}
                guard let humidity = day["humidity"] as? String else {return}
                
                let separatedTime = timeRaw.split(separator: "T").first
                guard let date = separatedTime?.split(separator: "-").last else {return}
                
                
                let fweather = ForecastWeather(code: Int(code)!, day: String(date), tc: tc, tmax: tmax, tmin: tmin, humidity: humidity, status: skyDesc)
                self.forecastWeather.append(fweather)
            }
            
            completed()
        }
    }
}


