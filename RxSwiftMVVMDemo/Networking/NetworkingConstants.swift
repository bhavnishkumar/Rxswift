//
//  NetworkingConstants.swift
//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 31/05/22.
//  Copyright © 2021 Bhavnish Mac. All rights reserved.
//

import Foundation
struct ApisURL {
    /// Base Url
    // MARK: - App URL's
    static let baseURl = "https://dummyapi.io/data/v1" //"https://jsonplaceholder.typicode.com"
    
    enum ServiceUrls: String {
        // MARK: - Common URLs
        // Auth
        case loginURl = "authentication/login"
        case userRegistration = "authentication/registration"
        // Home
        case getBanners = "authentication/sliderimage/userId"
        case photos = "/photos"
        case users = "/users"
        case posts =  "/post?limit="
    
    }
    
  
}
