//
//  PostModel.swift
//  RxSwiftMVVMDemo
//
//  Created by Admin on 14/07/22.
//

import Foundation



// MARK: - PostModel
struct PostModel: Codable {
    let data: [PostData]?
    let total, page, limit: Int?
}

// MARK: - PostData
struct PostData: Codable {
    let id: String?
    let image: String?
    let likes: Int?
    let tags: [String]?
    let text, publishDate: String?
    let owner: Owner?
    var selectedIndex:Int?
}

// MARK: - Owner
struct Owner: Codable {
    let id: String?
    let title: PostTitle?
    let firstName, lastName: String?
    let picture: String?
}

enum PostTitle: String, Codable {
    case miss = "miss"
    case mr = "mr"
    case mrs = "mrs"
    case ms = "ms"
}



