//
//  User.swift
//  APITestDemo
//
//  Created by Joy on 2019/8/19.
//  Copyright © 2019 Joy. All rights reserved.
//

import Foundation
import UIKit

class User {
    var userAccount: String
    var userIMG: UIImage
    var category: String
    init(userAccount: String, userIMG: UIImage, category: String) {
        self.userAccount = userAccount
        self.userIMG = userIMG
        self.category = category
    }
}
