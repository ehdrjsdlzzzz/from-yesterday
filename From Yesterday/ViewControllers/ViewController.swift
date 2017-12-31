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
    var forecastWeather: [ForecastWeather] = []
    
    let locationManager = CLLocationManager()
    var dateArray:[String.SubSequence] = []
    
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
        dateArray = stringDate.split(separator: "-")
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
                self.areaLabel.text = self.currentWeather?.city
                self.statusLabel.text = self.currentWeather?.status
                self.currentLabel.text = "\(self.currentWeather!.current)"
                self.minMaxLabel.text = "\(self.currentWeather!.max)/\(self.currentWeather!.min)"
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
            
            guard let forecast = forecastDays[0]["forecast"] as? [[String:Any]] else {return}
            forecast.forEach({print($0)})
            forecast.forEach({print($0["time"] as! String)})
            print("Country : \(country)")
            print("City : \(city)")
        }
    }
}


