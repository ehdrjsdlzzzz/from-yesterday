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
import ScalingCarousel

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var carouselView: ScalingCarouselView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var country:String?
    var city:String?
    
    var forecastWeather: [ForecastWeather] = []
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "From Yesterday"
        
        
        
        statusLabel.text = nil
        areaLabel.text = nil
        dateLabel.text = "Today"
        currentLabel.text = nil
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "logo")
        navigationItem.titleView = imageView

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        
        carouselView.register(UINib(nibName: weatherCell.reuseableIdentifier, bundle: nil), forCellWithReuseIdentifier: weatherCell.reuseableIdentifier)
    
        self.carouselView.delegate = self
        self.carouselView.dataSource = self
        
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

// MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(forecastWeather.count - 1)
        return forecastWeather.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherCell.reuseableIdentifier, for: indexPath)
        
        
        if let scailngCell = cell as? ScalingCarouselCell {
            scailngCell.mainView.layer.borderWidth = 2.0
            scailngCell.mainView.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselView.didScroll()
        guard let currentCenterIndex = carouselView.currentCenterCellIndex?.row else { return  }
        print(currentCenterIndex)
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
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.shared.lat = currentLocation.coordinate.latitude
            Location.shared.lon = currentLocation.coordinate.longitude
            
            self.forecastWeather.removeAll() // Initialize
            
            downloadCurrentWeather {
                print(Location.shared.lat)
                print(Location.shared.lon)
                let currentWeather = self.forecastWeather[0]
                self.areaLabel.text = "\(self.city!), \(self.country!) "
                self.statusLabel.text = currentWeather.status.uppercased()
                self.currentLabel.text = currentWeather.tc
                let weatherImage = Weather(rawValue:currentWeather.code)?.image()
                self.weatherIcon.image = UIImage(named: weatherImage!)
                SVProgressHUD.dismiss()
                self.carouselView.reloadData()
                
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
            
            for i in 0...4 {
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
                
                
                let fweather = ForecastWeather(code: Int(code)!, day: String(date), tc: tc.doubleToInt.degree, tmax: tmax.doubleToInt.degree, tmin: tmin.doubleToInt.degree, humidity: humidity, status: skyDesc)
                self.forecastWeather.append(fweather)
            }
            
            completed()
        }
    }
}


