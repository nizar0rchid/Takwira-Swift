//
//  MatchModel.swift
//  takwira
//
//  Created by Nizar on 25/12/2021.
//

import Foundation

struct MatchModel : Encodable, Decodable {
    var _id: String? = nil
    var teamCapacity : Int?
    var stadeId : String?
    var teamA: [String?]?
    var teamB: [String?]?
    
}
