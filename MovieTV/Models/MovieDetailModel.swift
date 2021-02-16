//
//  MovieDetailModel.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/14/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation

struct MovieDetailModel: Codable {
    let id: Int?
    let imdbID: String?
    let budget: Int?
    let genres: [GenreModel]?
    let homepage: String?
    let adult: Bool?
    let originalLanguage: String?
    let productionCompanies: [ProductionCompanyModel]?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let videos: MovieTrailerModel?
    let credits: MovieCreditsModel?
    let releases: MovieReleaseDatesModel?
    
    enum CodingKeys: String, CodingKey {
        case id, budget, genres, homepage, adult, revenue, runtime, status, videos, credits
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case productionCompanies = "production_companies"
        case releases = "release_dates"
    }
}

struct ProductionCompanyModel: Codable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct MovieTrailerModel: Codable {
    let results: [MovieTrailerVideo]?
    
    struct MovieTrailerVideo: Codable {
        let id: String?
        let key: String?
        let name: String?
        let site: String?
        let type: String?
    }
}

struct MovieCreditsModel: Codable {
    let cast: [CastCrewModel]?
    let crew: [CastCrewModel]?
    
    struct CastCrewModel: Codable {
        let adult: Bool?
        let gender: Int?
        let id: Int?
        let knownForDepartment: String?
        let name: String?
        let originalName: String?
        let popularity: Double?
        let profilePath: String?
        let castID: Int?
        let character: String?
        let creditID: String?
        let order: Int?
        let department: String?
        let job: String?
        
        enum CodingKeys: String, CodingKey {
            case adult, gender, id, name, popularity, character, order, job, department
            case knownForDepartment = "known_for_department"
            case originalName = "original_name"
            case profilePath = "profile_path"
            case castID = "cast_id"
            case creditID = "credit_id"
        }
    }
}

struct MovieReleaseDatesModel: Codable {
    let results: [ResultsModel]?
    
    var usableCertification: CertificationModel? {
        return results?.first(where: { $0.isoID == "US" })?.certifications?.first
    }
    
    struct ResultsModel: Codable {
        let isoID: String?
        let certifications: [CertificationModel]?
        
        enum CodingKeys: String, CodingKey {
            case isoID = "iso_3166_1"
            case certifications = "release_dates"
        }
    }
    
    struct CertificationModel: Codable {
        let certification: String?
        let note: String?
        let type: Int?
    }
}
