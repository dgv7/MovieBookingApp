//
//  File.swift
//  MovieBookingApp
//
//  Created by t2023-m0013 on 7/23/24.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String
    let overview: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
    }
}

class MovieService {
    static let shared = MovieService()
    private let apiKey = "a03d4de69feac73d515284c317000504"
    private let baseURL = "https://api.themoviedb.org/3"

    private init() {}

    func fetchMovies(endpoint: String, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseURL)/movie/\(endpoint)?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch movies: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(movieResponse.results)
            } catch {
                print("Failed to decode movies: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}
