//
//  PokemonsModel.swift
//  Poke
//
//  Created by Matt on 21/07/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

struct PokemonsModel: Codable {
    var next: URL?
    var pokemonsList: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        case next
        case pokemonsList = "results"
    }
}
