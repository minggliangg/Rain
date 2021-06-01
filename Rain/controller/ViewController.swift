//
//  ViewController.swift
//  Rain
//
//  Created by Ming Liang Khong on 31/5/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBAction func updateLocationPressed(_ sender: UIBarButtonItem) {
        locationManager.requestLocation()
    }
    
    
    let locationManager = CLLocationManager()
    var currentLatitude: Double = 0
    var currentLongitude: Double = 0
    var rainService = RainService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rainService.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        label.text = "Searching for your location..."
    }
}

extension ViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            let date_time = Date().ISO8601Format.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            rainService.fetchWeather(at: date_time)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: RainServiceDelegate {
    func didUpdateRealtimeRainfall(_ realtimeRainfall: RealtimeRainfall) {
        DispatchQueue.main.async {
            if let nearestLocation = realtimeRainfall.getNearestLocation(longitude: self.currentLongitude, latitude: self.currentLatitude){
                let statusImageName = self.rainService.getStatusImageView(reading: nearestLocation.reading)
                self.label.text = "You're near \(nearestLocation.name)\nCurrently it is \(nearestLocation.reading > 0 ? "raining":"not raining")"
                self.statusImageView.image = UIImage(systemName: statusImageName)
            }
        }
    }
}
