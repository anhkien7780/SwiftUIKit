//
//  MovieDetail.swift
//  MovieApp
//
//  Created by Admin on 6/16/25.
//

import Foundation

struct MovieDetail: Codable {
    let backdropPath: String?
    let genres: [Genre]
    let originalTitle: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let overview: String
    let runtime: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case overview
        case runtime
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
