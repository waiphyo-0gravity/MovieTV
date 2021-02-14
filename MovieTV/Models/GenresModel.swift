//
//  GenresModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

struct GenresResponseModel: Codable {
    let genres: [GenreModel]
}

struct GenreModel: Codable {
    let id: Int
    let name: String
    var isSelected: Bool = false
    
    enum CodingKeys: CodingKey {
        case id, name
    }
}
