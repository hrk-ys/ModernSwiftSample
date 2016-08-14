//
//  Repository.swift
//  ModernSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/08/14.
//  Copyright © 2016年 hiroki.yoshifuji. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Repository : Object, Mappable {
    
    dynamic var identifier: Int = 0
    dynamic var name: String!
    dynamic var desc: String!
    dynamic var url: String!
    
    override static func primaryKey() -> String? {
        return "identifier"
    }

    // MARK: JSON
    required convenience init?(_ map: Map) {
        self.init()
    }

    
    func mapping(map: Map) {
        identifier <- map["id"]
        name <- map["name"]
        desc <- map["description"]
        url <- map["html_url"]
    }
}
