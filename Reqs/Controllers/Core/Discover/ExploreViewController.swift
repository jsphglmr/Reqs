//
//  ExploreViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 4/24/22.
//
// todo:
// add realm support
// "edit" button in nav bar to move and delete cell
// swipe to delete folder


import UIKit
import RealmSwift
import Kingfisher
import CoreLocation

class ExploreViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let homeVC = HomeViewController()
    let jsonManager = JSONManager()
    var searchData: [Business]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: DiscoverCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        configureNavigationBar()
        DispatchQueue.main.async {
            self.getYelpResults()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Discover"

    }
    
    func getYelpResults() {
        let location = CLLocation(latitude: LocationManager.currentUserLocation.coordinate.latitude, longitude: LocationManager.currentUserLocation.coordinate.longitude)
        jsonManager.fetchHotResults(location: location) { result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(yelpData):
                self.searchData = yelpData.businesses
            }
        }
    }
}

//MARK: - UICollectionViewDelegate
extension ExploreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.identifier, for: indexPath) as? DiscoverCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        if let selectedCell = searchData?[indexPath.row] {
            cell.set(discoverCell: selectedCell)
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let currentCell = searchData?[indexPath.row] else { return }
        
        let annotationVC = AnnotationViewController(business: currentCell)
        navigationController?.present(annotationVC, animated: true)
        print("selected section:\(indexPath.section), row:\(indexPath.row)")
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ExploreViewController: UICollectionViewDelegateFlowLayout { // allows us to customize look of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/3)-3, height: (view.frame.width/3)-3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}
//MARK: - UICollectionViewDataSource
extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //always static due to yelp api return
        return 18
    }
}


