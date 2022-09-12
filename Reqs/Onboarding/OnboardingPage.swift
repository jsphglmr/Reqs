//
//  OnboardingPage1.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/15/22.
//

import UIKit

class OnboardingPage: UIViewController {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    var setBackgroundColor = UIColor()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var onboardingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var mainTitle: UILabel = {
        let label = titleLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var mainSubtitle: UILabel = {
        let label = subtitleLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()

    init(imageName: String, titleText: String, subtitleText: String, backgroundColor: UIColor) {
        super.init(nibName: nil, bundle: nil)
        onboardingImage.image = UIImage(named: imageName)
        mainTitle.text = titleText
        mainSubtitle.text = subtitleText
        setBackgroundColor = backgroundColor
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func layout() {
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(onboardingImage)
        stackView.addArrangedSubview(mainTitle)
        stackView.addArrangedSubview(mainSubtitle)
        
        
        view.backgroundColor = setBackgroundColor
        
        let stackViewConstraints = [
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let onboardingImageConstraints = [
            onboardingImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(onboardingImageConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
    }
}
