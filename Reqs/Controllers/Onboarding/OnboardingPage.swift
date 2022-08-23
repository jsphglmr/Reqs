//
//  OnboardingPage1.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/15/22.
//

import UIKit

class OnboardingPage1: UIViewController {
    
    private lazy var businessRating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String("\(yelpBusiness.rating!) / 5")
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
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
        let button = UIButton()
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    init(<#parameters#>) {
//        <#statements#>
//    }
}
