//
//  HomeEndPoint.swift
//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 31/05/22.
//  Copyright © 2021 Bhavnish Mac. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
enum HomeEndPoint: TargetType {
    
    case photos(limit:Int)
    
    var data: [String: Any] {
        switch self {
        default:
            return ["": ""]
        }
    }
    var service: String {
        switch self {
        case .photos(limit: let limit):
            return ApisURL.ServiceUrls.posts.rawValue + "\(limit)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            
        case .photos:
            return .get
        }
    }
    
    var isJSONRequest: Bool {
        switch self {
        case .photos:
            return false
        }
    }
    var multipartBody: MulitPartParam? {
        return nil
    }
    var headers: [String: String] {
        return createHeaders()
    }
    var instance: ApiManager {
        return .init(targetData: self)
    }
    
}

