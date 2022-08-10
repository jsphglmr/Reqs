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

class HomeViewController: UIViewController {
    
    let jsonManager = JSONManager()
    var searchData: [Business]? {
        didSet {
            addPins()
        }
    }
    
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    var reqsList: Results<ReqsModel>?
    
    var currentUserLocation = CLLocation()
    
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
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let image = UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: buttonConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var centerButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let image = UIImage(systemName: "location.fill.viewfinder", withConfiguration: buttonConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(reCenterButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var pinMyReqsButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let image = UIImage(systemName: "star.fill", withConfiguration: buttonConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pinMyReqsPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: - Selector Methods
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
    
    @objc func pinMyReqsPressed() {
        defer {
            refreshMap()
        }
        var pins: [YelpResultPins] = []
        if let data = reqsList {
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
            }
            for reqs in data {
                
                let coordinate = CLLocationCoordinate2D(latitude: reqs.latitude, longitude: reqs.longitude)
                let pin = YelpResultPins(title: reqs.name, address: reqs.address1, url: reqs.url, coordinate: coordinate, tag: nil)
                
                pins.append(pin)
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(pins)
            }
        }
        self.refreshRegionForPins(locations: [self.currentUserLocation])
    }
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        setupViews()
        loadReqs()
        checkIfLocationServicesIsEnabled()
    }
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(centerButton)
        view.addSubview(searchButton)
        view.addSubview(pinMyReqsButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let buttonSize = CGFloat(40)
        
        let mapConstraints = [
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        
        let searchButtonConstraints = [
            searchButton.centerYAnchor.constraint(equalTo: centerButton.centerYAnchor, constant: -75),
            searchButton.centerXAnchor.constraint(equalTo: centerButton.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: buttonSize),
            searchButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ]
        let centerButtonConstraints = [
            centerButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            centerButton.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            centerButton.widthAnchor.constraint(equalToConstant: buttonSize),
            centerButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ]
        
        let pinMyReqsButtonConstraints = [
            pinMyReqsButton.centerYAnchor.constraint(equalTo: centerButton.centerYAnchor, constant: 75),
            pinMyReqsButton.centerXAnchor.constraint(equalTo: centerButton.centerXAnchor),
            pinMyReqsButton.widthAnchor.constraint(equalToConstant: buttonSize),
            pinMyReqsButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ]
        
        NSLayoutConstraint.activate(mapConstraints)
        NSLayoutConstraint.activate(centerButtonConstraints)
        NSLayoutConstraint.activate(searchButtonConstraints)
        NSLayoutConstraint.activate(pinMyReqsButtonConstraints)
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
        var pins: [YelpResultPins] = []
        if let data = searchData {
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
            }
            var pinTag: Int = 0
            for business in data {
                let coordinate = CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
                let pin = YelpResultPins(title: business.name, address: business.location?.address1, url: business.url, coordinate: coordinate, tag: pinTag)
                pins.append(pin)
                pinTag += 1
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(pins)
            }
        }
    }
    
    func loadReqs() {
        reqsList = realm.objects(ReqsModel.self)
    }
    
    //workaround to refresh annotations on map view
    func refreshMap() {
        DispatchQueue.main.async {
            self.mapView.mapType = .mutedStandard
            self.mapView.mapType = .standard
        }
    }
    
//MARK: - Location
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
            let annotationVC = AnnotationViewController(business: searchData![pin.tag!])
            self.navigationController?.present(annotationVC, animated: true)
        }
    }
}
