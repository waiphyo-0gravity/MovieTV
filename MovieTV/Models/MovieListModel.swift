//
//  MovieListModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

struct MovieListModel: Codable {
    let results: [MovieModel]
}

struct MovieModel: Codable {
    let id: Int
    let title: String?
    let genreIDs: [Int]
    let originalLanguage: String?
    let originalTitle: String?
    let posterPath: String?
    let video: Bool?
    let voteAverage: Double?
    let overview: String?
    let releaseDate: String?
    var voteCount: Int?
    let adult: Bool?
    let backdropPath: String?
    let popularity: Double?
    
    enum CodingKeys: String, CodingKey {
        case genreIDs = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case video, overview, title, adult, id, popularity
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case voteCount = "vote_count"
        case backdropPath = "backdrop_path"
    }
}
