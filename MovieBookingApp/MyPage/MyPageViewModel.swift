import Foundation

class MyPageViewModel {
    
    var bookedMovies: [Movie] = []
    var wantedMovies: [Movie] = []
    
    func fetchBookedMovies(completion: @escaping () -> Void) {
        MovieService.shared.fetchMovies(endpoint: "upcoming") { movies in
            if let movies = movies {
                self.bookedMovies = movies
            }
            completion()
        }
    }
    
    func fetchWantedMovies(completion: @escaping () -> Void) {
        MovieService.shared.fetchMovies(endpoint: "popular") { movies in
            if let movies = movies {
                self.wantedMovies = movies
            }
            completion()
        }
    }
}
