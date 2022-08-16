//
//  ReqsViewControllerTests.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/16/22.
//

import XCTest
@testable import Reqs

class ReqsViewControllerTests: XCTestCase {
    
    var VC: ReqsViewController?

    override func setUpWithError() throws {
        VC = ReqsViewController()
        
    }
    
    func testConvertReqModelToBusinessModel_whenPassedReq_returnsBusiness() {
        
        let mocknewReq = ReqsModel()
        mocknewReq.dateCreated = Date.now
        mocknewReq.name = ""
        mocknewReq.url = ""
        mocknewReq.imageUrl = ""
        mocknewReq.rating = 0.0
        mocknewReq.price = ""
        mocknewReq.phone = ""
        mocknewReq.city = ""
        mocknewReq.country = ""
        mocknewReq.state = ""
        mocknewReq.address1 = nil
        mocknewReq.address2 = nil
        mocknewReq.address3 = nil
        mocknewReq.zipCode = nil
        mocknewReq.latitude = 0.0
        mocknewReq.longitude = 0.0

        let mockBusinessModel = ReqsViewController.convertReqModelToBusinessModel(mocknewReq)
        
        XCTAssert((mockBusinessModel as Any) is Business)        
        
    }

//    @Persisted var name: String
//    @Persisted var url: String
//    @Persisted var imageUrl: String
//    @Persisted var rating: Double?
//    @Persisted var price: String?
//    @Persisted var phone: String?
//
//    @Persisted var city: String
//    @Persisted var country: String
//    @Persisted var state: String
//    @Persisted var address1: String?
//    @Persisted var address2: String?
//    @Persisted var address3: String?
//    @Persisted var zipCode: String?
//
//    @Persisted var latitude: Double
//    @Persisted var longitude: Double
//
//    @Persisted var alias: String?
//
//    @Persisted var dateCreated: Date?
//
    
}
