//
//  OnboardingLocation.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/22/22.
//

import UIKit

class OnboardingLocation: UIViewController {
    
    var setBackgroundColor = UIColor()
    
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
    }
}
