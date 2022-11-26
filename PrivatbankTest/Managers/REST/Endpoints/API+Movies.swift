//
//  API+Movies.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import Moya

extension API {
    enum Auth {
        case searchMovies(query: String, page: Int)
    }
}

extension API.Auth: TargetType {
    var baseURL: URL {
        return URL(string: SettingsManager.environment.restHost)!
    }
    
    var path: String {
        switch self {
        case .searchMovies:
            return "search/movie"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchMovies:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .searchMovies(let query, let page):
            let parameters: [String: Any] = [
                "api_key": SettingsManager.APIToken,
                "query": query,
                "page": page
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        nil
    }
}

extension APIManager {
    enum Movies {
        static var provider = MoyaProvider<API.Auth>(plugins: [NetworkLoggerPlugin()])
        
        static func search(query: String, page: Int, completion: @escaping (Result<SearchMovieResponseObject, Error>) -> Void) {
            APIManager.request(provider: APIManager.Movies.provider, target: .searchMovies(query: query, page: page), completion: completion)
        }
        
        static func getPosterDownloadURL(for posterID: String) -> URL? {
            URL(string: "https://image.tmdb")
        }
    }
}
