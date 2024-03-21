//
//  AnnotationViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 7/4/22.
//

import UIKit
import MapKit
import RealmSwift
import Kingfisher

class AnnotationViewController: UIViewController {
    //MARK: - inits & references
    lazy var realm: Realm = {
        return try! Realm()
    }()
    var reqsList: Results<ReqsModel>?
    let yelpBusiness: Business
    
    init(business: Business) {
        self.yelpBusiness = business
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: - UI components - buttons, labels
    private lazy var businessImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        let url = URL(string: yelpBusiness.imageUrl)
        imageView.kf.setImage(with: url)
        imageView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return imageView
    }()
    private lazy var stackView: UIStackView = {
      let stackView = UIStackView()
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.axis = .horizontal
      stackView.alignment = .center
      stackView.distribution = .fill
      stackView.spacing = 10
      return stackView
    }()
    
    private lazy var businessName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = yelpBusiness.name
        label.font = .systemFont(ofSize: 32, weight: .black)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var businessNameSubtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let city = yelpBusiness.location?.city, let state = yelpBusiness.location?.state {
            label.text = String("\(city), \(state)")
        } else {
            label.text = nil
        }
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var businessPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let price = yelpBusiness.price {
            label.text = "Price: \(price)"
        } else {
            label.text = nil
        }
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var businessRating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String("\(yelpBusiness.rating!) / 5")
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var callButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
          var outgoing = incoming
          outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
          return outgoing
        }
        config.image = UIImage(systemName: "phone.fill")
        config.imagePadding = 5
        config.imagePlacement = .top
        config.title = "Call"
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
            guard let number = self.yelpBusiness.phone else {  print("yelp error"); return }
            guard var url = URL(string: "tel://\(number)") else { print("url error"); return }
            UIApplication.shared.open(url)
        }))
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
    
    private lazy var safariButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
          var outgoing = incoming
          outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
          return outgoing
        }
        config.image = UIImage(systemName: "safari.fill")
        config.imagePadding = 5
        config.imagePlacement = .top
        config.title = "Safari"
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
            if let url = URL(string: self.yelpBusiness.url) {
                UIApplication.shared.open(url)
            }
        }))
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
    
    private lazy var directionsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
          var outgoing = incoming
          outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
          return outgoing
        }
        config.image = UIImage(systemName: "map.fill")
        config.imagePadding = 5
        config.imagePlacement = .top
        config.title = "Maps"
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
            let coordinate = CLLocationCoordinate2D(latitude: self.yelpBusiness.coordinates.latitude, longitude: self.yelpBusiness.coordinates.longitude)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDefault]
            self.title = self.yelpBusiness.name
            mapItem.name = self.title
            mapItem.openInMaps(launchOptions: launchOptions)
        }))
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()

    private lazy var saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
          var outgoing = incoming
          outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
          return outgoing
        }
        config.image = UIImage(systemName: "folder.fill.badge.plus")
        config.imagePadding = 5
        config.imagePlacement = .top
        config.title = "Save to My Reqs"
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        let button = UIButton(type: .custom, primaryAction: UIAction(handler: { _ in
            let newReq = ConvertModels.convertBusinessToReqs(yelp: self.yelpBusiness)
            self.save(profile: newReq)
        }))
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
    
    //MARK: - View configuration
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
          self.dismiss(animated: true)
        })
        print(yelpBusiness)
        configureViews()
    }
    
    private func configureViews() {
        //add blur to entire view
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        view.addSubview(blurEffectView)
        view.addSubview(businessImage)
        view.addSubview(businessName)
        view.addSubview(businessNameSubtitle)
        view.addSubview(businessPrice)
        view.addSubview(businessRating)
        view.addSubview(saveButton)

        view.addSubview(stackView)
        stackView.addArrangedSubview(callButton)
        stackView.addArrangedSubview(safariButton)
        stackView.addArrangedSubview(directionsButton)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        let safeSize = CGFloat(view.frame.width - 50)
        
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: businessName.bottomAnchor, constant: 85)
        ]
        
        let businessImageConstraints = [
            businessImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            businessImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            businessImage.heightAnchor.constraint(equalToConstant: safeSize),
            businessImage.widthAnchor.constraint(equalToConstant: safeSize)
        ]
        
        let businessNameConstraints = [
            businessName.topAnchor.constraint(equalTo: businessImage.bottomAnchor, constant: 10),
            businessName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        
        let businessNameSubtitleConstraints = [
            businessNameSubtitle.topAnchor.constraint(equalTo: businessName.bottomAnchor, constant: 5),
            businessNameSubtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        
        let saveButtonConstraints = [
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]

        let businessPriceConstraints = [
            businessPrice.bottomAnchor.constraint(equalTo: businessImage.topAnchor),
            businessPrice.leadingAnchor.constraint(equalTo: businessImage.leadingAnchor, constant: 20)
        ]
        
        let businessRatingConstraints = [
            businessRating.bottomAnchor.constraint(equalTo: businessImage.topAnchor),
            businessRating.trailingAnchor.constraint(equalTo: businessImage.trailingAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(businessImageConstraints)
        NSLayoutConstraint.activate(businessNameConstraints)
        NSLayoutConstraint.activate(businessNameSubtitleConstraints)
        NSLayoutConstraint.activate(saveButtonConstraints)
        NSLayoutConstraint.activate(businessPriceConstraints)
        NSLayoutConstraint.activate(businessRatingConstraints)
    }

//MARK: - Realm
    func save(profile: ReqsModel) {
        let acSuccess = UIAlertController(title: "Added!", message: nil, preferredStyle: .alert)
        let acFail = UIAlertController(title: "Error Saving Req", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Continue", style: .default)
        acSuccess.addAction(action)
        do {
            try realm.write({
                realm.add(profile)
            })
            present(acSuccess, animated: true)
        } catch {
            print("error saving : \(error)")
            present(acFail, animated: true)
        }
    }
}

