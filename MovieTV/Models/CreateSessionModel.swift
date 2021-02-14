//
//  CreateSessionModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/12/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

struct CreateSessionModel: Codable {
    let success: Bool
    let sessionID: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}
