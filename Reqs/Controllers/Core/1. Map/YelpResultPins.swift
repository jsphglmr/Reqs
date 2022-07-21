//
//  YelpResultPins.swift
//  Reqs
//
//  Created by Joseph Gilmore on 6/22/22.
//

import MapKit
import Foundation

class YelpResultPins: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let url: String?
    var coordinate: CLLocationCoordinate2D
    var tag: Int
    
    init(title: String?, address: String?, url: String?, coordinate: CLLocationCoordinate2D, tag: Int) {
        self.title = title
        self.locationName = address
        self.coordinate = coordinate
        self.url = url
        self.tag = tag
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
