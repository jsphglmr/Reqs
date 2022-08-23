//
//  OnboardingPage1.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/15/22.
//

import UIKit

class OnboardingPage: UIViewController {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    var setBackgroundColor = UIColor()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
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
        imageView.image = UIImage(named: imageName)
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
        stackView.addArrangedSubview(mainTitle)
        stackView.addArrangedSubview(mainSubtitle)
        
        view.backgroundColor = setBackgroundColor
        
        let stackViewConstraints = [
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
    }
}
