//
//  StadeModel.swift
//  takwira
//
//  Created by Nizar on 25/12/2021.
//

import Foundation
struct StadeModel: Encodable, Decodable {
    var _id: String? = nil
    var name: String?
    var capacity: Int?
    var price: Float?
    var location: String?
    var phone: String?
    var DateTime: String?
    var image: String? = nil
}
