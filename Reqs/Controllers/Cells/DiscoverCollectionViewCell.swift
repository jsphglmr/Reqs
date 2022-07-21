//
//  DiscoverCollectionViewCell.swift
//  Reqs
//
//  Created by Joseph Gilmore on 6/7/22.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiscoverCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
//        pull images by name and assigns them randomly to imageView.image
//        replace with images from api -jojo
        let images = [
            UIImage(named: "testimage1"),
            UIImage(named: "testimage2"),
            UIImage(named: "testimage3"),
            UIImage(named: "testimage4"),
            UIImage(named: "testimage5"),
            UIImage(named: "testimage6"),
        ].compactMap({ $0 }) // remove any nil images
        imageView.image = images.randomElement()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.image = nil
    }
}
