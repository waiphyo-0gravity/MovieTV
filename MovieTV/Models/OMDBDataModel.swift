//
//  OMDBDataModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/16/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

struct OMDBDataModel: Codable {
    let rated: String?
    let ratings: [OMDBDataRating]?
    let imdbRating: String?
    let imdbVotes: String?
    
    enum CodingKeys: String, CodingKey {
        case imdbRating, imdbVotes
        case rated = "Rated"
        case ratings = "Ratings"
    }
    
    struct OMDBDataRating: Codable {
        let source: String?
        let value: String?
        
        enum CodingKeys: String, CodingKey {
            case source = "Source"
            case value = "Value"
        }
    }
}
