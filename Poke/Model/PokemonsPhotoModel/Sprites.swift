//
//  Sprites.swift
//  Poke
//
//  Created by Matt on 22/07/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

struct Sprites: Codable {
    var frontDefault: URL?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
