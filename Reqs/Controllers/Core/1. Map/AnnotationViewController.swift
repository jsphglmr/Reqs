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
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        let buttonSize = CGFloat(75)
        
        let businessImageConstraints = [
            businessImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            businessImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            businessImage.heightAnchor.constraint(equalToConstant: 300),
            businessImage.widthAnchor.constraint(equalToConstant: 300)
        ]
        
        let businessNameConstraints = [
            businessName.topAnchor.constraint(equalTo: businessImage.bottomAnchor, constant: 10),
            businessName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let addButtonConstraints = [
            addButton.bottomAnchor.constraint(equalTo: businessImage.topAnchor, constant: 5),
            addButton.centerXAnchor.constraint(equalTo: businessImage.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: buttonSize),
            addButton.widthAnchor.constraint(equalToConstant: buttonSize)
            
        ]
        
        let linkButtonConstraints = [
            linkButton.bottomAnchor.constraint(equalTo: businessImage.topAnchor, constant: 5),
            linkButton.centerXAnchor.constraint(equalTo: businessImage.leadingAnchor, constant: 20),
            linkButton.heightAnchor.constraint(equalToConstant: buttonSize),
            linkButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        
        NSLayoutConstraint.activate(businessImageConstraints)
        NSLayoutConstraint.activate(businessNameConstraints)
        NSLayoutConstraint.activate(addButtonConstraints)
        NSLayoutConstraint.activate(linkButtonConstraints)
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
