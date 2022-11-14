//
//  SkeletonDiscoverCollectionViewCell.swift
//  Reqs
//
//  Created by Joseph Gilmore on 11/13/22.
//

import UIKit

extension SkeletonDiscoverCollectionViewCell: SkeletonLoadable {}

class SkeletonDiscoverCollectionViewCell: UICollectionViewCell {
    static let identifier = "SkeletonDiscoverCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
}
