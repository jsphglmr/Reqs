//
//  HomeViewControllerTests.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/16/22.
//

import XCTest
import CoreLocation

class HomeViewControllerTests: XCTestCase {
    
    var VC: MockHomeViewController?
    
    private var locationManager: CLLocationManager = {
        let location = CLLocationManager()
        return location
    }()


    override func setUpWithError() throws {
        VC = MockHomeViewController()

    }
    
}

//func addPins() {
//    var pins: [YelpResultPins] = []
//    if let data = searchData {
//        DispatchQueue.main.async {
//            self.mapView.removeAnnotations(self.mapView.annotations)
//        }
//        var pinTag: Int = 0
//        for business in data {
//            let coordinate = CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
//            let pin = YelpResultPins(title: business.name, address: business.location?.address1, url: business.url, coordinate: coordinate, tag: pinTag)
//            pins.append(pin)
//            pinTag += 1
//        }
//        DispatchQueue.main.async {
//            self.mapView.addAnnotations(pins)
//        }
//    }
//}
