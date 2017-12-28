//
//  ViewController.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 28..
//  Copyright © 2017년 이동건. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SVProgressHUD

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
   
    var currentWeather: Weather?
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        degreeLabel.text = nil
        areaLabel.text = nil
        dateLabel.text = nil
        
        setCurrentDate()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()

        }
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
}

// MARK: CLLocationManagerDelegate
extension ViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getUserLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude, completed: {
                print("finish")
                guard let currentWeather = self.currentWeather else {return}
                self.locationManager.pausesLocationUpdatesAutomatically = true
                self.locationManager.stopUpdatingLocation()
                var area = ""
                area += currentWeather.city
                if let county = currentWeather.county {
                    area += " \(county)"
                }
                
                if let village = currentWeather.village {
                    area += " \(village)"
                }
                
                self.areaLabel.text = area
                self.degreeLabel.text = currentWeather.status
//                SVProgressHUD.dismiss()
            })
        }
    }
    
    func getUserLocation(lat:CLLocationDegrees, lon: CLLocationDegrees, completed: @escaping (()->())){
        print("Tracking...!")
        let headers: HTTPHeaders = [
            "appKey" : "1fde96e3-0f5e-3f0c-86d2-a949fd339c14"
        ]
        let url = "http://apis.skplanetx.com/weather/current/hourly?version=1&lat=\(lat)&lon=\(lon)"
        Alamofire.request(url, headers: headers).responseJSON(completionHandler: { (response) in
            SVProgressHUD.show()
            guard let result = response.result.value as? [String : Any] else { return }
            guard let weather = result["weather"] as? [String: Any] else {return}
            guard let weatherHourly = weather["hourly"] as? [[String: Any]] else {return}
            guard let grid = weatherHourly[0]["grid"] as? [String: String] else {return}
            guard let sky = weatherHourly[0]["sky"] as? [String : String] else { return }
            guard let skyStatus = sky["name"] else {return}
            guard let city = grid["city"] else {return}
            
            self.currentWeather = Weather(city: city, status: skyStatus)
            if let county = grid["county"] {
                print(county)
                self.currentWeather?.county = county
            }
            
            if let village = grid["village"] {
                print(village)
                self.currentWeather?.village = village
            }
            
        
            completed()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "사용자 위치 정보가 필요합니다.",
                                                message: "애플리케이션을 이용하시려면 위치 서비스를 사용하셔야 합니다.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
