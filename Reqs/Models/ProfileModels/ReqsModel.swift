//
//  ReqsModel.swift
//  Reqs
//
//  Created by Joseph Gilmore on 6/8/22.
//

import Foundation
import RealmSwift

class ReqsModel: Object {
    @Persisted var name: String
    @Persisted var url: String
    @Persisted var imageUrl: String
    @Persisted var rating: Double?
    @Persisted var price: String?
    @Persisted var phone: String?
    
    @Persisted var city: String
    @Persisted var country: String
    @Persisted var state: String
    @Persisted var address1: String?
    @Persisted var address2: String?
    @Persisted var address3: String?
    @Persisted var zipCode: String?
    
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    
    @Persisted var alias: String?
    
    @Persisted var dateCreated: Date?

    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<ProfileModel>
}
