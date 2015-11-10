//
//  WeatherPage.swift
//  NewsReader
//
//  Created by Harold on 15/8/20.
//  Copyright © 2015年 GetStarted. All rights reserved.
//


import UIKit
import CoreLocation

let weatherPageSBId = "WeatherPage"
let weatherUrlFmt = "http://api.k780.com:88/?app=weather.today&weaid=%@&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json"

class WeatherPage: BaseNavPage ,CLLocationManagerDelegate{
    
    @IBOutlet var cityLabel:UILabel!
    @IBOutlet var dayLabel:UILabel!
    @IBOutlet var temperatureLabel:UILabel!
    @IBOutlet var currentTempLabel:UILabel!
    @IBOutlet var weatherLabel:UILabel!
    @IBOutlet var windLabel:UILabel!
    @IBOutlet var humiLabel:UILabel!
    @IBOutlet var imageView:UIImageView!
    
    var CLManager:CLLocationManager?
    var currentCity:String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.startLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func startLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            CLManager = CLLocationManager()
            CLManager?.delegate = self
            CLManager?.desiredAccuracy = kCLLocationAccuracyBest
            CLManager?.distanceFilter = 100
            CLManager?.startUpdatingLocation()
            
            if !ZHGlobal.isSystemLowerIOS8() {
                CLManager?.requestAlwaysAuthorization()
            }
        }
        
    }
    
    func searchCityName(location:CLLocation) {
        
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location) { (placeMarks, error) -> Void in
            
            if let marks = placeMarks {
                for mark in marks {
                    print(mark.name)
                    print(mark.locality)
                    self.currentCity = mark.locality
                    
                    self.executeGetWeatherOp()
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Location Manager satatus:\(status)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.searchCityName(newLocation)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        searchCityName(location)
        CLManager?.stopUpdatingLocation()
    }
    
    func executeGetWeatherOp() {
        
        self.pleaseWait()
        var cityName = currentCity?.componentsSeparatedByString("市")[0]
        cityName = cityName?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = NSString(format: weatherUrlFmt, cityName!)
        print(url)
        let dictInfo = ["url":url]
        
        _operation = ZHGetWeather(initwithdelegate: self, opInfo: dictInfo)
        _operation?.executeOp()
    }
    
    override func opSuccess(data: AnyObject) {
        
        self.clearAllNotice()
        super.opSuccess(data)
        self.updateUI(data as! WeatherInfo)
    }
    
    func updateUI(info:WeatherInfo) {
        
        cityLabel.text = info.cityName
        dayLabel.text = info.day
        temperatureLabel.text = info.temperature
        currentTempLabel.text = info.currentTemp
        weatherLabel.text = info.name as String
        windLabel.text = info.wind! + " " + info.windGrad!
        humiLabel.text = info.humidity
        
    }
    
//    @IBAction func backBtnOnTouched(sender:UIButton) {
    
//        self.dismissViewControllerAnimated(true) { () -> Void in
//            
//        }
//        self.navigationController?.popViewControllerAnimated(true)

//    }
    
}