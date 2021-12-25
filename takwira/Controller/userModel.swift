//
//  userModel.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import Foundation

struct userModel: Encodable, Decodable {
    var _id: String? = nil
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var age: Int?
    var phone: String?
    var location: String?
    var role: String?
    var token: String? = nil
    var profilePic: String? = nil
}
