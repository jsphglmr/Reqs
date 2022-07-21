//
//  ProfileModel.swift
//  Reqs
//
//  Created by Joseph Gilmore on 6/8/22.
//

import Foundation
import RealmSwift

class ProfileModel: Object {
    
    //set up realm model
    
    @Persisted var profile: String = ""
    @Persisted var items = List<ReqsModel>()
    
    convenience init(profile: String) {
        self.init()
        self.profile = profile
    }
}
