//
//  MapViewModel.swift
//  Reqs
//
//  Created by Joseph Gilmore on 3/20/24.
//

import Foundation
import MapKit

class MapViewModel {
    let locationManager = LocationManager()
    
    func centerMapOnUserLocation (locations: [CLLocation], mapView: MKMapView) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: 2500, longitudinalMeters: 2500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func refreshRegionForPins (locations: [CLLocation], mapView: MKMapView) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: 2500, longitudinalMeters: 2500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addPins(data searchData: [Business]?, mapView: MKMapView) {
        var pins: [YelpResultPins] = []
        if let data = searchData {
            DispatchQueue.main.async {
                mapView.removeAnnotations(mapView.annotations)
            }
            var pinTag: Int = 0
            for business in data {
                let coordinate = CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
                let pin = YelpResultPins(title: business.name, address: business.location?.address1, url: business.url, coordinate: coordinate, tag: pinTag)
                pins.append(pin)
                pinTag += 1
            }
            DispatchQueue.main.async {
                mapView.addAnnotations(pins)
            }
        }
    }

}
