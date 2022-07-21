//
//  ReqsModel.swift
//  Reqs
//
//  Created by Joseph Gilmore on 6/8/22.
//

import Foundation
import RealmSwift

class ReqsModel: Object {
    
    @Persisted var title: String = ""
    @Persisted var dateCreated: Date?
    
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<ProfileModel>
}
