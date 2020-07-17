//
//  ViewController.swift
//  WeatherLogger
//
//  Created by Akanksha garg on 16/07/20.
//  Copyright © 2020 Akanksha garg. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var weatherInfoTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Variables
    let locationManager = CLLocationManager()
    let weatherVM = WeatherViewModel()
    private let control: UIRefreshControl = UIRefreshControl()
    let estimatedRowHeight = 450.00
    var showError: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLocationPermission()
        // Do any additional setup after loading the view.
    }
    
    /// Method called when data is required from server or from local json file for unit testing
    func loadData(longitude: Double, latitude: Double) {
        
        let requestData = ["APPID": Keys.KWeatherAPI, "lat": String(latitude), "lon": String(longitude)]
        NetworkManager.shared().callGetAPI(apiURL: API.kCurrentWeatherData, requestData: requestData) { (error: Error?, blogArray: WeatherData?) in
            
            if let error = error {
                self.showError?(String(describing: error))
                return
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func getLocationPermission() {
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
        }
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.loadData(longitude: locValue.longitude, latitude: locValue.latitude)
        
    }
}
