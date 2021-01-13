//
//  URLHelper.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

enum URLHelper: String {
    case requestToken = "/authentication/token/new"
    
    static let baseURL = "https://api.themoviedb.org/3"
    
    var url: URL? {
        switch self {
        case .requestToken:
            return URL(string: "\(Self.baseURL)\(rawValue)")
        }
    }
}
