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
        //add functionality to open settings > privacy
        let ac = UIAlertController(title: "Location Services not enabled", message: "Please enable Location Services in the Settings app to enable this functionality", preferredStyle: .alert)
        let cont = UIAlertAction(title: "Cancel", style: .cancel)
        let settings = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        ac.addAction(cont)
        ac.addAction(settings)
//        present(ac, animated: true)
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization()
        } else {
            //add new alert action to open settings app
            locationPermissionDenied()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            LocationManager.currentUserLocation = userLocation
        } else {
            print("present error ; saving user location")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
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
