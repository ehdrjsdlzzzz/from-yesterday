//
//  TodayViewController.swift
//  From Yesterday Widget
//
//  Created by 이동건 on 2018. 1. 4..
//  Copyright © 2018년 이동건. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import Alamofire

class WidgetWeather {
    var code:Int
    var city:String
    var country:String
    var desc:String
    var tc:String
    var tmax:String
    var tmin:String
    
    init(code:Int, city:String, country:String, desc:String, tc:String, tmax:String, tmin:String) {
        self.code = code
        self.city = city
        self.country = country
        self.desc = desc
        self.tc = tc
        self.tmax = tmax
        self.tmin = tmin
    }
}

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate{
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tcLabel: UILabel!
    @IBOutlet weak var tmaxminLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather:WidgetWeather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        areaLabel.text = nil
        descLabel.text = nil
        tcLabel.text = nil
        tmaxminLabel.text = nil
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        locationAuthStatus()
        completionHandler(NCUpdateResult.newData)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
}

extension TodayViewController {
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.shared.lat = currentLocation.coordinate.latitude
            Location.shared.lon = currentLocation.coordinate.longitude
            
            print(Location.shared.lat)
            print(Location.shared.lon)
            
            downloadCurrentFunction(completed: {
                let weatherImage = Weather(rawValue: self.currentWeather.code)?.image()
                self.iconView.image = UIImage(named: weatherImage!)
                self.areaLabel.text = "\(self.currentWeather.city), \(self.currentWeather.country)"
                self.descLabel.text = self.currentWeather.desc.uppercased()
                self.tcLabel.text = self.currentWeather.tc
                self.tmaxminLabel.text = "\(self.currentWeather.tmax) / \(self.currentWeather.tmin)"
            })

        }
    }
}

extension TodayViewController {
    func downloadCurrentFunction(completed: @escaping ()->()){
        Alamofire.request(CURRENT_WEATHER_URL, headers: HTTP_HEADER).responseJSON { (response) in
            guard let value = response.result.value as? [String:Any] else {return}
            guard let gweather = value["gweather"] as? [String:Any] else {return}
            guard let current = gweather["current"] as? [[String:Any]] else {return}
            guard let location = current[0]["location"] as? [String:String] else {return}
            guard let city = location["city"] else {return}
            guard let country = location["country"] else {return}
            
            guard let sky = current[0]["sky"] as? [String:String] else {return}
            guard let temp = current[0]["temperature"] as? [String:String] else {return}
            
            guard let desc = sky["name"] else {return}
            guard let code = sky["code"] else {return}
            guard let tc = temp["tc"] else {return}
            guard let tmax = temp["tmax"] else {return}
            guard let tmin = temp["tmin"] else {return}
        
            self.currentWeather = WidgetWeather(code: Int(code)!, city: city, country: country, desc: desc, tc: tc.doubleToInt.degree, tmax: tmax.doubleToInt.degree, tmin: tmin.doubleToInt.degree)
            completed()
        }
    }
}
