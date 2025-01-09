//
//  GoogleHTMLAPI.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-06.
//

import Foundation

enum GoogleHTMLAPI {
    case search
    
    var url: URL? {
        switch self {
        case .search:
            var components = URLComponents(string: self.host)
            components?.path = self.path
            components?.queryItems = self.queryItems
            return components?.url
        }
    }
    
    var host: String {
        return SearchConstants.host
    }
    
    var path: String {
        // Assemble complex paths here depending on the type
        switch self {
        case .search:
            return SearchConstants.searchPath
        }
    }
    
    var queryItems: [URLQueryItem] {
        // Assemble standard query params here depending on the type
        switch self {
        case .search:
            return [
                URLQueryItem(name: SearchConstants.noFixResultsKey, value: "1")
            ]
        }
    }
}
