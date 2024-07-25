import Foundation

class MyPageViewModel {
    
//    var bookedMovies: [Movie] = []
    var bookedMovies: [Booking] = []
    var wantedMovies: [Movie] = []
    
    func fetchBookedMovies(completion: @escaping () -> Void) {
            if let email = UserDefaultsManager.shared.getEmail() {
                self.bookedMovies = UserDefaultsManager.shared.getBookings(for: email)
            }
            completion()
        }
    
//    func fetchBookedMovies(completion: @escaping () -> Void) {
//        MovieService.shared.fetchMovies(endpoint: "upcoming") { movies in
//            if let movies = movies {
//                self.bookedMovies = movies
//            }
//            completion()
//        }
//    }
    
    func fetchWantedMovies(completion: @escaping () -> Void) {
        MovieService.shared.fetchMovies(endpoint: "popular") { movies in
            if let movies = movies {
                self.wantedMovies = movies
            }
            completion()
        }
    }
}
