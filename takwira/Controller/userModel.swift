//
//  userModel.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import Foundation

struct userModel: Encodable {
    var _id: String? = nil
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let age: Int
    let phone: String
    let location: String
    let role: String
    let token: String? = nil
}
