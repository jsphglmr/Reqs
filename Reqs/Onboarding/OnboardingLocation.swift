//
//  OnboardingLocation.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/22/22.
//

import UIKit

class OnboardingLocation: UIViewController {
    
    var setBackgroundColor = UIColor()
    let locationManager = LocationManager()
    
    fileprivate lazy var locationButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }
        config.image = UIImage(systemName: "location.circle.fill")
        config.imagePadding = 8
        config.imagePlacement = .trailing
        config.title = "Enable Location Services"
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        button.tintColor = .systemGray
        button.titleLabel?.textColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
    
    init(backgroundColor: UIColor) {
        super.init(nibName: nil, bundle: nil)
        setBackgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = setBackgroundColor
        
        view.addSubview(locationButton)
        
        let locationButtonTappedConstraints = [
            locationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(locationButtonTappedConstraints)
    }
    
    @objc func locationButtonTapped() {
        locationManager.checkIfLocationServicesIsEnabled {
            if self.locationManager.authorizationStatus == .authorizedAlways || self.locationManager.authorizationStatus == .authorizedWhenInUse {
                self.locationButton.configuration?.title = "Location Enabled!"
            }
        }
    }
}
