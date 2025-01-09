//
//  Constants.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-06.
//

import Foundation

enum SearchConstants {
    
    static let host = "https://www.google.com"
    static let searchPath = "/search"
    
    // Query Parameters
    static let searchKey = "q"
    static let startPointerKey = "start" // Results paginated in multiples of 10
    static let searchTypeKey = "udm" // See SearchType enum
    static let noFixResultsKey = "nfpr"
    
    // Properties
    static let thumbKey = "thumb"
    
}

enum SearchType: Int, CaseIterable {
    case text = 0
    case image
    case video
    
    var udm: Int {
        switch self {
            case .text: return 1
            case .image: return 2
            case .video: return 7
        }
    }
    
    var textValue: String {
        switch self {
        case .text: return "Text"
        case .image: return "Image"
        case .video: return "Video"
        }
    }
}
