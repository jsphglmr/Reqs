//
//  HomeViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 4/24/22.
//

import UIKit
import MapKit
import RealmSwift
import CoreLocation
//MARK: - Home VC

class HomeViewController: UIViewController {
    
    let jsonManager = JSONManager()
    var searchData: [Business]? {
        didSet {
            addPins()
        }
    }
    
    var currentUserLocation = CLLocation()
    private let locationButton = UIButton(type: .system)
    
//MARK: - Views & Buttons
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
    }()
    
    private var locationManager: CLLocationManager = {
        let location = CLLocationManager()
        return location
    }()
    
    private lazy var centerButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "location.fill.viewfinder")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(reCenterButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "magnifyingglass.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()

//MARK: - Core
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        setupViews()
        checkIfLocationServicesIsEnabled()
    }
    
    @objc private func searchButtonPressed() {
        let ac = UIAlertController(title: "Search", message: "What are you looking for?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let search = UIAlertAction(title: "Search", style: .default) { _ in
            if let text = ac.textFields?.first?.text {
                let searchText = text.replacingOccurrences(of: " ", with: "%20")
                self.getYelpResults(term: searchText, location: self.currentUserLocation)
                self.refreshRegionForPins(locations: [self.currentUserLocation])
            }
        }
        ac.addAction(search)
        ac.addAction(cancel)
        ac.addTextField()
        present(ac, animated: true)
    }
    
    @objc func reCenterButtonPressed() {
        locationManager.requestLocation()
    }
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(centerButton)
        view.addSubview(searchButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let mapConstraints = [
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        
        let centerButtonConstraints = [
            centerButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            centerButton.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ]
        
        let searchButtonConstraints = [
            searchButton.centerYAnchor.constraint(equalTo: centerButton.centerYAnchor, constant: -75),
            searchButton.centerXAnchor.constraint(equalTo: centerButton.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(mapConstraints)
        NSLayoutConstraint.activate(centerButtonConstraints)
        NSLayoutConstraint.activate(searchButtonConstraints)
    }
    
    func centerMapOnUserLocation (locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func refreshRegionForPins (locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(region, animated: true)
        }
    }

    func addPins() {
        defer {
            refreshMap()
        }
        
        if let data = searchData {
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
            }
            
            var pinTag: Int = 0
            
            for business in data {
                let coordinate = CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
                let pin = YelpResultPins(title: business.name, address: business.location?.address1, url: business.url, coordinate: coordinate, tag: pinTag)
                pinTag += 1
                
                mapView.addAnnotation(pin)
            }
        }
    }
   
    //workaround to refresh annotations on map view
    func refreshMap() {
        DispatchQueue.main.async {
            self.mapView.mapType = .mutedStandard
            self.mapView.mapType = .standard
        }
    }
    
    func locationPermissionDenied() {
        //add functionality to open settings > privacy
        let ac = UIAlertController(title: "Location Services not enabled", message: "Please enable Location Services in the Settings app to enable this functionality", preferredStyle: .alert)
        let cont = UIAlertAction(title: "Continue", style: .cancel)
        ac.addAction(cont)
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
    
//MARK: - JSON / Data
    func getYelpResults(term: String, location: CLLocation) {
        jsonManager.fetchYelpResults(term: term, location: location) { result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(yelpData):
                
                self.searchData = yelpData.businesses
            }
        }
    }
}

//MARK: - Map Delegate
extension HomeViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnUserLocation(locations: locations)
        
        if let userLocation = locations.last {
            currentUserLocation = userLocation
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

    //adds the annotationview for each pin on the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? YelpResultPins else {
            return nil
        }
        
        let identifier = "pin"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let pin = view.annotation as? YelpResultPins {
            let annotationVC = AnnotationViewController(business: searchData![pin.tag])
            self.navigationController?.present(annotationVC, animated: true)
        }
    }
}
