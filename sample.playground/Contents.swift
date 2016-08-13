//: Playground - noun: a place where people can play

import Foundation
//import Alamofire
import Moya

import XCPlayground

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

extension API: TargetType {
    var baseURL: NSURL { return NSURL(string: "https://api.github.com/")! }
    var path: String {
        switch self {
        case .Repositories: return "repositories"
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

let provider = MoyaProvider<API>()
provider.request(.Repositories) { result in
    // do something with the result (read on for more details)
    print(result)
}


/*
enum Router: URLRequestConvertible {
    static let baseURLString = "http://example.com"
    static let perPage = 50
    
    case Search(query: String, page: Int)
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let result: (path: String, parameters: [String: AnyObject]) = {
            switch self {
            case .Search(let query, let page) where page > 0:
                return ("/search", ["q": query, "offset": Router.perPage * page])
            case .Search(let query, _):
                return ("/search", ["q": query])
            }
        }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: result.parameters).0
    }
}


Alamofire.request(Router.Search(query: "foo bar", page: 1))
    .responseJSON { (response) in
        debugPrint(response)
}
 */

//
//Alamofire.request(.GET, "https://api.github.com/repositories")
//    .validate(statusCode: 200..<300)
//    .responseJSON { response in
//        debugPrint(response)
//
//        print(response.request)  // original URL request
//        print(response.response) // URL response
////        print(response.data)     // server data
//        print(response.result)   // result of response serialization
//        
//        if let JSON = response.result.value {
//            print("JSON: \(JSON)")
//        }
//        if let error = response.result.error {
//            print("error: \(error)")
//        }
//}

XCPSetExecutionShouldContinueIndefinitely()
