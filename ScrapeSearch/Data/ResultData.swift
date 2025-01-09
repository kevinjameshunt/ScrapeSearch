//
//  ResultData.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-06.
//

import Foundation

struct SearchResult: Decodable {
    let siteTitle: String
    let siteURL: String
    let pageTitle: String
    let pageDescription: String
    let thumbnailURL: String?
}
