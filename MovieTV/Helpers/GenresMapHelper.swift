//
//  GenresMapHelper.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/14/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

class GenresMapHelper {
    static let shared = GenresMapHelper()
    
    var genres: [GenreModel] = []
    
    func getGenres(for id: Int) -> GenreModel? {
        return genres.first(where: { $0.id == id })
    }
    
    func mapGenres(for ids: [Int]?) -> [GenreModel] {
        return ids?.compactMap { id in
            return genres.first(where: { $0.id == id })
        } ?? []
    }
}
