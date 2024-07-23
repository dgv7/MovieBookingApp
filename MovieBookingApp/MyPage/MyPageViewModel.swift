//
//  MyPageViewModel.swift
//  MovieBookingApp
//
//  Created by 김동건 on 7/22/24.
//

import Foundation

struct Movie {
    let posterName: String
    let title: String
}

class MyPageViewModel {
    
    let bookedMovies: [Movie] = [
        Movie(posterName: "poster1", title: "Title 1"),
        Movie(posterName: "poster2", title: "Title 2"),
        Movie(posterName: "poster3", title: "Title 3"),
        Movie(posterName: "poster4", title: "Title 4"),
        Movie(posterName: "poster5", title: "Title 5")
    ]
    
    let wantedMovies: [Movie] = [
        Movie(posterName: "poster6", title: "Title 6"),
        Movie(posterName: "poster7", title: "Title 7"),
        Movie(posterName: "poster8", title: "Title 8"),
        Movie(posterName: "poster9", title: "Title 9"),
        Movie(posterName: "poster10", title: "Title 10")
    ]
}
