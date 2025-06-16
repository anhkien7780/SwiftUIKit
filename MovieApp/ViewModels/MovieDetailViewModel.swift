//
//  MainViewModel.swift
//  MovieApp
//
//  Created by Admin on 6/16/25.
//

import Foundation


class MovieDetailViewModel {
    private let movieIDs = [634649, 429617]
    var selectedMovie: MovieDetail?
    
    init(selectedMovie: MovieDetail){
        self.selectedMovie = selectedMovie
    }
    var movies: [MovieDetail?] = [] {
        didSet {
            onDataUpdated?()
        }
    }
    
    init(){}
   

    var onDataUpdated: (() -> Void)?

    func loadMovieDetail() {
        
        movies = Array(repeating: nil, count: movieIDs.count)

        for (index, id) in movieIDs.enumerated() {
            MovieServices.fetchMovieDetail(imageID: id) { [weak self] result in
                switch result {
                case .success(let movie):
                    self?.movies[index] = movie
                    self?.onDataUpdated?()
                case .failure(let error):
                    print("Lỗi khi lấy phim: \(error)")
                }
            }
        }
    }
}


