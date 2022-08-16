//
//  OnboardingViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/15/22.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    let initialPage = 0
    
}

extension OnboardingViewController {
    
    func configure() {
        dataSource = self
        delegate = self
        
        pageControl.addAction(UIAction(handler: { _ in
            
        }), for: .valueChanged)
        
        let page1 = OnboardingPage1()
        let page2 = OnboardingPage2()
        let page3 = OnboardingPage3()
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        setupView()
    }
    
    func setupView() {
        
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
    
}
