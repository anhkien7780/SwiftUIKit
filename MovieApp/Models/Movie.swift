//
//  Movie.swift
//  MovieApp
//
//  Created by Admin on 6/16/25.
//

import Foundation

class Movie{
    let imageNamed: String
    let title: String
    let averageRate: String
    let genre: String
    let year: String
    let runtime: String
    
    init(imageNamed: String, title: String, averageRate: String, genre: String, year: String, runtime: String) {
        self.imageNamed = imageNamed
        self.title = title
        self.averageRate = averageRate
        self.genre = genre
        self.year = year
        self.runtime = runtime
    }
}
