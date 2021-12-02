//
//  liveMatchModel.swift
//  takwira
//
//  Created by Nizar on 28/11/2021.
//

import Foundation

struct liveMatchModel: Encodable, Decodable {
    var country : String?
    var league : String?
    var venue : String?
    var homeName : String?
    var awayName : String?
    var elapsed : Int?
    var elapsedPlus : Int?
    var team_home_goals : Int?
    var team_away_goals : Int?
}
