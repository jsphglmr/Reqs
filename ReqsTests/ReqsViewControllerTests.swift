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
        
        let mockBusinessModel = ConvertModels.convertReqsToBusiness(mocknewReq)
        
        XCTAssert((mockBusinessModel as Any) is Business)        
        
    }
    
}
