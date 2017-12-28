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

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        degreeLabel.text = nil
        areaLabel.text = nil
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()

        }
    }
}

extension ViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getUserLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude, completed: { (area, sky) in
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let stringDate: String = dateFormatter.string(from: date)
                let dateArray = stringDate.split(separator: "-")
                print(dateArray)
                self.locationManager.pausesLocationUpdatesAutomatically = true
                self.locationManager.stopUpdatingLocation()
                self.areaLabel.text = area
                self.degreeLabel.text = sky
                self.dateLabel.text = "Today : \(dateArray[2])년 \(dateArray[1])월 \(dateArray[0])일"
            })
        }
    }
    
    func getUserLocation(lat:CLLocationDegrees, lon: CLLocationDegrees, completed: @escaping ((String, String)->())){
        let headers: HTTPHeaders = [
            "appKey" : "cb1e61d2-515c-398c-a45c-fd7dc8aba004"
        ]
        let url = "http://apis.skplanetx.com/weather/current/minutely?version=1&lat=\(lat)&lon=\(lon)"
        print(lat, lon)
        Alamofire.request(url, headers: headers).responseJSON(completionHandler: { (response) in
            guard let result = response.result.value as? [String : Any] else { return }
            guard let weather = result["weather"] as? [String: Any] else {return}
            guard let weatherHourly = weather["minutely"] as? [[String: Any]] else {return}
            guard let station = weatherHourly[0]["station"] as? [String: String] else {return}
            guard let sky = weatherHourly[0]["sky"] as? [String : String] else { return }
            guard let skyStatus = sky["name"] else {return}
            guard let area = station["name"] else {return}
            
            print(weather)
            completed(area, skyStatus)
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
