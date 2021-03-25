//
//  AccountDetailModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 3/25/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

struct AccountDetailModel: Codable {
    let avatar: AvatarModel?
    let id: Int?
    let name: String?
    let includeAdult: Bool?
    let username: String?
    
    enum CodingKeys: String, CodingKey {
        case avatar, id, name, username
        case includeAdult = "include_adult"
    }
}

struct AvatarModel: Codable {
    let gravatar: GravatarModel?
    
    struct GravatarModel: Codable {
        let hash: String?
    }
    
    struct TMDbModel: Codable {
        let avatarPath: String?
        
        enum CodingKeys: String, CodingKey {
            case avatarPath = "avatar_path"
        }
    }
}
