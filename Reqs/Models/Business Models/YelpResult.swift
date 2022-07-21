//
//  YelpResult.swift
//  Reqs
//
//  Created by Joseph Gilmore on 6/9/22.
//

import UIKit

struct YelpResult: Codable {
    var businesses: [Business]
    var total: Int
}

struct Business: Codable {
    var name: String
    var url: String
    var imageUrl: String
    var location: Location?
    var coordinates: Coordinates
    var categories: [Category]?
    var rating: Double?
    var price: String?
    var phone: String?

    struct Location: Codable {
        var city: String
        var country: String
        var state: String
        var address1: String?
        var address2: String?
        var address3: String?
        var zipCode: String?
    }

    struct Coordinates: Codable {
        var latitude: Double
        var longitude: Double
    }
}

struct Category: Codable {
    var alias: String?
    var title: String?
}
