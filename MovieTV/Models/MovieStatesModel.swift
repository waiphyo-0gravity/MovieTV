//
//  MovieStatesModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/27/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

struct MovieStatesModel: Codable {
    let id: Int?
    var favorite: Bool?
    var rated: RatedType?
    var watchlist: Bool?
    
    enum RatedType: Codable {
        case ratedStatus(Bool)
        case ratedStatusData(RatedStatusData)
        
        init(from decoder: Decoder) throws {
            let container = try? decoder.singleValueContainer()
            
            if let ratedStatus = try? container?.decode(Bool.self) {
                self = .ratedStatus(ratedStatus)
                return
            }
            
            if let ratedStatusData = try? container?.decode(RatedStatusData.self) {
                self = .ratedStatusData(ratedStatusData)
                return
            }
            
            throw DecodingError.typeMismatch(RatedType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type!"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .ratedStatus(let value):
                try container.encode(value)
            case .ratedStatusData(let value):
                try container.encode(value)
            }
        }
    }

    struct RatedStatusData: Codable {
        let value: Float?
    }
}
