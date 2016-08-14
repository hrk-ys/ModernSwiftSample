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

typealias APIProvider = RxMoyaProvider<API>

private func JSONResponseDataFormatter(data: NSData) -> NSData {
    do {
        let dataAsJSON = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let prettyData =  try NSJSONSerialization.dataWithJSONObject(dataAsJSON, options: .PrettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

extension API {
    
    static func DefaultProvider() -> APIProvider {
        return RxMoyaProvider<API>(plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)])
    }
    
    static func StubProvider() -> APIProvider {
        return RxMoyaProvider(stubClosure: MoyaProvider.ImmediatelyStub)
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
            return .GET
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
            return stubbedResponse("Repositories")
        }
    }
    var multipartBody: [MultipartFormData]? {
        // Optional
        return nil
    }
}


func stubbedResponse(filename: String) -> NSData! {
    @objc class TestClass: NSObject { }
    
    let bundle = NSBundle(forClass: TestClass.self)
    let path = bundle.pathForResource(filename, ofType: "json")
    return NSData(contentsOfFile: path!)
}

