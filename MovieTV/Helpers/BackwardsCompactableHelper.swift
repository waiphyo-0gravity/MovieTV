//
//  BackwardsCompactableHelper.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

class BackwardsCompactableHelper {
    static func setDefaultAPIKeyIfNeeded() {
        guard UserDefaultsHelper.shared.apiKey == nil else { return }
        
        UserDefaultsHelper.shared.apiKey = "5d426f341099601fa75eea89f7598909"
    }
}
