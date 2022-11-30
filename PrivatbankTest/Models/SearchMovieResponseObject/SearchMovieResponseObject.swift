//
//  SearchMovieResponseObject.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

/*
 {
   "page": 1,
   "results": [MovieObject],
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
