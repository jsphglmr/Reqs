//
//  OnboardingViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/15/22.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    let initialPage = 0
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .systemBackground
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var closeOnboardingButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(closeOnboardingTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var continueButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }
        config.image = UIImage(systemName: "arrow.turn.down.right")
        config.imagePadding = 8
        config.imagePlacement = .trailing
        config.title = "Continue"
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        configure()
        setupViews()
    }
    
    func configure() {
        let page1 = OnboardingPage(imageName: "testimage1", titleText: "Welcome to Reqs!", subtitleText: "", backgroundColor: .systemGray2)
        let page2 = OnboardingLocation(backgroundColor: .systemGray6)
        let page3 = OnboardingPage(imageName: "testimage2", titleText: "Revisit your favorite places", subtitleText: "", backgroundColor: .systemGray4)
        //        let page4 = OnboardingLogin()
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        //        pages.append(page4)
        
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(pageControl)
        view.addSubview(continueButton)
        view.addSubview(closeOnboardingButton)
        
        let pageControlConstraints = [
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 2)
        ]
        
        let continueButtonConstraints = [
            continueButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -30),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let closeOnboardingButtonConstraints = [
            closeOnboardingButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            closeOnboardingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(pageControlConstraints)
        NSLayoutConstraint.activate(continueButtonConstraints)
        NSLayoutConstraint.activate(closeOnboardingButtonConstraints)
    }
    
    @objc func closeOnboardingTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func continueButtonTapped() {
        if pageControl.currentPage == 2 {
            self.dismiss(animated: true)
        } else if pageControl.currentPage == 1 {
            continueButton.configuration?.title = "Go to Reqs!"
            pageControl.currentPage += 1
            goToNextPage()
        } else {
            continueButton.configuration?.title = "Continue"
            pageControl.currentPage += 1
            goToNextPage()
        }
    }
    
    @objc func pageControlTapped() {
        
    }
    
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
}

//MARK: - Datasources
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == 0 {
            return pages.last // go to last vc
        } else {
            return pages[currentIndex - 1] // go to previous vc
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1] // go to next vc
        } else {
            return pages.first // go to first vc
        }
    }
}

//MARK: - Delegates

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}
