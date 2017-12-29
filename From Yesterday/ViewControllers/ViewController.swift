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
            
            downloadForcastWeather {
                self.areaLabel.text = self.currentWeather?.area
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

// MARK: Download CurrentWeather

extension ViewController {
    func downloadForcastWeather(completed: @escaping ()->() ){
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { (response) in
            guard let result = response.result.value as? [String:Any] else {return}
            guard let weather = result["weather"] as? [[String:Any]] else {return}
            guard let main = result["main"] as? [String:Double] else {return}
            guard let sys = result["sys"] as? [String:Any] else {return}
            
            guard let name = result["name"] as? String else {return}
            
            guard let weatherStatus = weather[0]["main"] as? String else {return}
            guard let currentTemp = main["temp"] else {return}
            guard let humidity = main["humidity"] else {return}
            guard let todayMax = main["temp_max"] else {return}
            guard let todayMin = main["temp_min"] else {return}
            guard let country = sys["country"] as? String else {return}
            
            let currentToCelcius = currentTemp - 273.15
            let minToCelcius = todayMin - 273.15
            let maxToCelcius = todayMax - 273.15
            
            self.currentWeather = CurrentWeather(country: country, area: name, status: weatherStatus, current: Double.rounded(currentToCelcius), humidity: humidity, min: Double.rounded(minToCelcius), max: Double.rounded(maxToCelcius))
            
            completed()
        }
    }
}


