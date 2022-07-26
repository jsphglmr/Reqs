//
//  LocationManager.swift
//  Reqs
//
//  Created by Joseph Gilmore on 9/1/22.
//

import UIKit
import CoreLocation

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    static var currentUserLocation = CLLocation()
    
    private var locationManager: CLLocationManager = {
        let location = CLLocationManager()
        return location
    }()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

//MARK: - Location
    func locationPermissionDenied() {
        let ac = UIAlertController(title: "Location Services not enabled", message: "Please enable Location Services in the Settings app to enable this functionality", preferredStyle: .alert)
        let cont = UIAlertAction(title: "Cancel", style: .cancel)
        let settings = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        ac.addAction(cont)
        ac.addAction(settings)
//        present(ac, animated: true)
    }
    
    func checkIfLocationServicesIsEnabled(completed: @escaping ()->()) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.checkLocationAuthorization()
            } else {
                //add new alert action to open settings app
                self.locationPermissionDenied()
            }
            completed()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            LocationManager.currentUserLocation = userLocation
        } else {
            print("present error; saving user location")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //only check for user location automatically when denied or restricted
        let status = locationManager.authorizationStatus
        if status == .denied, status == .restricted {
            checkLocationAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationPermissionDenied()
        case .denied:
            locationPermissionDenied()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error \(error.localizedDescription)")
    }
}
