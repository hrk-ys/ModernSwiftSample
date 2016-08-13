//
//  API.swift
//  ModernSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/08/13.
//  Copyright © 2016年 hiroki.yoshifuji. All rights reserved.
//

import Foundation
import Moya


private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    var UTF8EncodedData: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}


enum API {
    case Repositories
    

}

extension API {
    static func DefaultProvider() -> MoyaProvider<API> {
        return MoyaProvider<API>()
    }
    
    static func StubProvider() -> MoyaProvider<API> {
        return MoyaProvider(stubClosure: MoyaProvider.ImmediatelyStub)
    }
}

extension API: TargetType {
    var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }
    var path: String {
        switch self {
        case .Repositories: return "/repositories"
        }
    }
    var method: Moya.Method {
        switch self {
        case .Repositories:
            return .POST
        }
    }
    var parameters: [String: AnyObject]? {
        switch self {
        case .Repositories:
            return nil
        }
    }
    var sampleData: NSData {
        switch self {
        case .Repositories:
            return "{\"id\": 100, \"first_name\": \"foo\", \"last_name\": \"var\"}".UTF8EncodedData
        }
    }
    var multipartBody: [MultipartFormData]? {
        // Optional
        return nil
    }
}

