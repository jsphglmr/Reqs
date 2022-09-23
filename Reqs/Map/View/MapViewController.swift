//
//  HomeViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 4/24/22.
//

import UIKit
import MapKit
import RealmSwift

class MapViewController: UIViewController {
    
    let jsonManager = JSONManager()
    var reqsList: Results<ReqsModel>?
    let locationManager = LocationManager()
    var searchData: [Business]? {
        didSet {
            guard let data = searchData, data.count > 0 else { return }
            addPins()
        }
    }
    
    lazy var realm: Realm = {
        return try! Realm()
    }()

    
    //MARK: - Views & Buttons
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
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
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupViews()
        loadReqs()
        presentOnboarding()
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
    
    func presentOnboarding() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "hasLaunched")
        if launchedBefore {
            locationManager.checkIfLocationServicesIsEnabled {
                self.centerMapOnUserLocation(locations: [LocationManager.currentUserLocation])
            }
            return
        } else {
            present(OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal), animated: true)
            UserDefaults.standard.set(true, forKey: "hasLaunched")
        }
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
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: 2500, longitudinalMeters: 2500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addPins() {
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
//MARK: - Objc Methods
extension MapViewController {
    @objc private func searchButtonPressed() {
        let ac = UIAlertController(title: "Search", message: "What are you looking for?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let search = UIAlertAction(title: "Search", style: .default) { _ in
            if let text = ac.textFields?.first?.text {
                let searchText = text.replacingOccurrences(of: " ", with: "%20")
                self.getYelpResults(term: searchText, location: LocationManager.currentUserLocation)
                self.refreshRegionForPins(locations: [LocationManager.currentUserLocation])
            }
        }
        ac.addAction(search)
        ac.addAction(cancel)
        ac.addTextField()
        present(ac, animated: true)
    }
    
    @objc func reCenterButtonPressed() {
        locationManager.checkIfLocationServicesIsEnabled {
            self.centerMapOnUserLocation(locations: [LocationManager.currentUserLocation])
        }
    }
    
    @objc func pinMyReqsPressed() {
        searchData = []
        var pins: [YelpResultPins] = []
        if let data = reqsList {
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
            }
            var pinTag: Int = 0
            for reqs in data {
                let coordinate = CLLocationCoordinate2D(latitude: reqs.latitude, longitude: reqs.longitude)
                let pin = YelpResultPins(title: reqs.name, address: reqs.address1, url: reqs.url, coordinate: coordinate, tag: pinTag)
                pins.append(pin)
                pinTag += 1
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(pins)
            }
        }
        locationManager.checkIfLocationServicesIsEnabled {
            self.refreshRegionForPins(locations: [LocationManager.currentUserLocation])
        }
    }
}

//MARK: - Map Delegate
extension MapViewController: MKMapViewDelegate {

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
        if let pin = view.annotation as? YelpResultPins, let safeTag = pin.tag {
            if let safeData = searchData, safeData.count > 0 {
                let annotationVC = AnnotationViewController(business: safeData[safeTag])
                self.navigationController?.present(annotationVC, animated: true)
            } else {
                guard let reqs = reqsList else { return }
                let annotationVC = AnnotationViewController(business: ConvertModels.convertReqsToBusiness(reqs[safeTag]))
                self.navigationController?.present(annotationVC, animated: true)
            }
        }
    }
}
