//
//  RequestTokenModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

struct RequestTokenModel: Codable {
    let success: Bool
    let expireAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expireAt = "expires_at"
        case requestToken = "request_token"
    }
}
