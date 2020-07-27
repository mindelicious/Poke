//
//  DetailPokemonModel.swift
//  Poke
//
//  Created by Matt on 22/07/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

struct DetailPokemonModel: Codable {
    var abilities: [Ability]
    var baseExperience: Int?
    var height: Int?
    var sprites: Sprites
    var weight: Int?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case height
        case sprites
        case weight
        case name
    }
}
