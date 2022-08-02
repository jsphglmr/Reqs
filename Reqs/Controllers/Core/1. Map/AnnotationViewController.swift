//
//  AnnotationViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 7/4/22.
//

import UIKit
import Kingfisher

class AnnotationViewController: UIViewController {
        
    let yelpBusiness: Business
    init(business: Business) {
        self.yelpBusiness = business
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        return nil
    }
    
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
    
    private lazy var businessName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = yelpBusiness.name
        label.font = .systemFont(ofSize: 24, weight: .black)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var businessPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = yelpBusiness.price!
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var businessRating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(yelpBusiness.rating!)
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "folder.fill.badge.plus")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "safari.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var businessInfo: UITextView = {
        let text = UITextView()
        text.text = "More Info:\n\nAddress: \(yelpBusiness.location!.address1!), \(yelpBusiness.location!.city), \(yelpBusiness.location!.state)\nPhone Number:  \(yelpBusiness.phone!)"
        text.font = .systemFont(ofSize: 16, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemBackground
        return text
    }()
    
    override func viewDidLoad() {
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
        view.addSubview(addButton)
        view.addSubview(linkButton)
        view.addSubview(businessInfo)
        view.addSubview(businessPrice)
        view.addSubview(businessRating)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        let buttonSize = CGFloat(75)
        let safeSize = CGFloat(view.frame.width - 50)
        
        let businessImageConstraints = [
            businessImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            businessImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            businessImage.heightAnchor.constraint(equalToConstant: safeSize),
            businessImage.widthAnchor.constraint(equalToConstant: safeSize)
        ]
        
        let businessNameConstraints = [
            businessName.topAnchor.constraint(equalTo: businessImage.bottomAnchor, constant: 10),
            businessName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let addButtonConstraints = [
            addButton.bottomAnchor.constraint(equalTo: businessImage.topAnchor, constant: 15),
            addButton.centerXAnchor.constraint(equalTo: businessImage.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: buttonSize),
            addButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        
        let linkButtonConstraints = [
            linkButton.bottomAnchor.constraint(equalTo: businessImage.topAnchor, constant: 15),
            linkButton.centerXAnchor.constraint(equalTo: businessImage.leadingAnchor, constant: 20),
            linkButton.heightAnchor.constraint(equalToConstant: buttonSize),
            linkButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        
        let businessInfoConstraints = [
            businessInfo.topAnchor.constraint(equalTo: businessName.bottomAnchor, constant: 25),
            businessInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            businessInfo.heightAnchor.constraint(equalToConstant: safeSize),
            businessInfo.widthAnchor.constraint(equalToConstant: safeSize)
        ]
        
        let businessPriceConstraints = [
            businessPrice.topAnchor.constraint(equalTo: businessImage.bottomAnchor, constant: 10),
            businessPrice.centerXAnchor.constraint(equalTo: businessName.trailingAnchor, constant: 45),
            businessPrice.centerYAnchor.constraint(equalTo: businessName.centerYAnchor)
        ]
        
        let businessRatingConstraints = [
            businessRating.topAnchor.constraint(equalTo: businessImage.bottomAnchor, constant: 10),
            businessRating.centerXAnchor.constraint(equalTo: businessName.leadingAnchor, constant: -45),
            businessRating.centerYAnchor.constraint(equalTo: businessName.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(businessImageConstraints)
        NSLayoutConstraint.activate(businessNameConstraints)
        NSLayoutConstraint.activate(addButtonConstraints)
        NSLayoutConstraint.activate(linkButtonConstraints)
        NSLayoutConstraint.activate(businessInfoConstraints)
        NSLayoutConstraint.activate(businessPriceConstraints)
        NSLayoutConstraint.activate(businessRatingConstraints)
    }
    
    @objc private func addButtonPressed() {
        //this code will allow you to select which folder you want to save your pin to 
    }
    
    @objc private func linkButtonPressed() {
        if let url = URL(string: yelpBusiness.url) {
            UIApplication.shared.open(url)
        }
    }
}
