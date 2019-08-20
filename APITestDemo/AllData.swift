//
//  AllData.swift
//  APITestDemo
//
//  Created by joyy on 2019/8/19.
//  Copyright © 2019 Joy. All rights reserved.
//

import Foundation

struct AllData: Codable {
    var success: Success?
    var contents: Contents?
}

struct Success: Codable {
    let total: Int?
}

struct Contents: Codable {
    var quotes: [Quote]?
    let copyright : String?
}

struct Quote: Codable {
    var quote: String?
    var author: String?
    var tags: [String]?
    var date: String?
}





