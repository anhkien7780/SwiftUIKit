//
//  MovieServices.swift
//  MovieApp
//
//  Created by Admin on 6/16/25.
//

import Foundation

class MovieServices {
    static private let apiKey = "b6089aedb1274752de2f1022865a15ac"

    static func fetchMovieDetail(
        imageID: Int,
        completion: @escaping (Result<MovieDetail, Error>) -> Void
    ) {
        let urlString = "https://api.themoviedb.org/3/movie/\(imageID)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NoData", code: 0)))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let movie = try decoder.decode(MovieDetail.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(movie))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
