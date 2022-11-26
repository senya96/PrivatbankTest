//
//  SettingsManager.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import Foundation

class SettingsManager {
    public static let APIToken = "5f55ca842d0a87ce000f89dbeafff045"
    
    enum Server {
        case stage
    }
    
    static var environment: Server = .stage
}

extension SettingsManager.Server {
    
    /// Base API  host
    var baseIP: String {
        switch self {
        case .stage: return "themoviedb.org"
        }
    }
    
    /// API requests base protocol
    var apiProtocol: String {
        "https"
    }
    
    /// API requests port
    var apiPort: String {
        ""
    }
    
    var apiVersion: String {
        "3"
    }
    
    /// Resulting API endpoint
    var  restHost: String {
        return "\(apiProtocol)://api.\(baseIP)\(apiPort)/\(apiVersion)"
    }
    
    func getPosterURL(for posterPath: String) -> URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}
