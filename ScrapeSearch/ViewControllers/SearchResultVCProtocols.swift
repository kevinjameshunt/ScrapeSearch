//
//  SearchResultVCProtocols.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-08.
//

import Foundation

protocol SearchResultsReceiver {
    func updateWithSearchResults(_ results: [SearchResult])
}

protocol SearchResultsPaginationDelegate: AnyObject {
    func requestNextPageAtPointer(_ startPointer: Int)
}
