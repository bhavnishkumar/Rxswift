//
//  PhotosModel.swift
//  RxSwiftMVVMDemo
//
//  Created by Admin on 14/07/22.
//

import Foundation


// MARK: - PhotosModelElement
struct PhotosModel: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}




