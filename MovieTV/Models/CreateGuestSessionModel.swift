//
//  CreateGuestSessionMode.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/22/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

struct CreateGuestSessionModel: Codable {
    let success: Bool
    let guestSessionID: String
    let expiresAt: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionID = "guest_session_id"
        case expiresAt = "expires_at"
    }
}
