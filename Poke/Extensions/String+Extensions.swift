//
//  String+Extensions.swift
//  Poke
//
//  Created by Matt on 23/07/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
