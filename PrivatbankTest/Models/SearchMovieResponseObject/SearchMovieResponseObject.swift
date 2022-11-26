//
//  SearchMovieResponseObject.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

/*
 {
   "page": 1,
   "results": [
     {
       "poster_path": "/cezWGskPY5x7GaglTTRN4Fugfb8.jpg",
       "adult": false,
       "overview": "When an unexpected enemy emerges and threatens global safety and security, Nick Fury, director of the international peacekeeping agency known as S.H.I.E.L.D., finds himself in need of a team to pull the world back from the brink of disaster. Spanning the globe, a daring recruitment effort begins!",
       "release_date": "2012-04-25",
       "genre_ids": [
         878,
         28,
         12
       ],
       "id": 24428,
       "original_title": "The Avengers",
       "original_language": "en",
       "title": "The Avengers",
       "backdrop_path": "/hbn46fQaRmlpBuUrEiFqv0GDL6Y.jpg",
       "popularity": 7.353212,
       "vote_count": 8503,
       "video": false,
       "vote_average": 7.33
     }
   ],
   "total_results": 14,
   "total_pages": 1
 }
 */

// MARK: - SearchMovieResponseObject
struct SearchMovieResponseObject: Codable {
    let page: Int?
    let results: [MovieObject]?
    let totalResults: Int?
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct MovieObject: Codable {
    let posterPath: String?
    let adult: Bool?
    let overview: String?
    let releaseDate: String?
    let genreIDs: [Int]?
    let id: Int?
    let originalTitle: String?
    let originalLanguage: String?
    let title: String?
    let backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}
