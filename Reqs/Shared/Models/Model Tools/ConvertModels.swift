//
//  ConvertModel.swift
//  Reqs
//
//  Created by Joseph Gilmore on 9/14/22.
//

import Foundation

class ConvertModels {
    
    static func convertReqsToBusiness(_ reqModel: ReqsModel) -> Business {
        let location = Business.Location(city: reqModel.city,
                                         country: reqModel.country,
                                         state: reqModel.state,
                                         address1: reqModel.address1,
                                         address2: reqModel.address2,
                                         address3: reqModel.address3,
                                         zipCode: reqModel.zipCode)
        let coordinates = Business.Coordinates(latitude: reqModel.latitude, longitude: reqModel.longitude)
        let business = Business(name: reqModel.name,
                                url: reqModel.url,
                                imageUrl: reqModel.imageUrl,
                                location: location,
                                coordinates: coordinates,
                                categories: nil,
                                rating: reqModel.rating,
                                price: reqModel.price,
                                phone: reqModel.phone)
        return business
    }
        
    static func convertBusinessToReqs(yelp: Business) -> ReqsModel {
        let newReq = ReqsModel()
        newReq.dateCreated = Date.now
        newReq.name = yelp.name
        newReq.url = yelp.url
        newReq.imageUrl = yelp.imageUrl
        newReq.rating = yelp.rating
        newReq.price = yelp.price
        newReq.phone = yelp.phone
        newReq.city = yelp.location?.city ?? ""
        newReq.country = yelp.location?.country ?? ""
        newReq.state = yelp.location?.state ?? ""
        newReq.address1 = yelp.location?.address1
        newReq.address2 = yelp.location?.address2
        newReq.address3 = yelp.location?.address3
        newReq.zipCode = yelp.location?.zipCode
        newReq.latitude = yelp.coordinates.latitude
        newReq.longitude = yelp.coordinates.longitude
        return newReq
    }
}
