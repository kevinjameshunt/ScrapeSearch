//
//  GoogleSearchService.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-06.
//

import Foundation

protocol SearchService {
    func search(query: String, type: SearchType, startPointer: Int) async throws -> [SearchResult]
}

/// Using Google's web-based search interface intstead of it's API
class GoogleSearchService: SearchService{
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func search(query: String, type: SearchType, startPointer: Int = 0) async throws -> [SearchResult] {
        guard let searchURL = self.getSearchURL(query: query, type: type, startPointer: startPointer) else {
            throw URLError(.badURL)
        }
        
        // Attempt 1: Retrieve the HTML response from the server
//        let data = try await self.networkService.fetch(url: searchURL)
//        let resultDataString = String(decoding: data, as: UTF8.self)
//        guard !resultDataString.isEmpty else { 
//            throw URLError(.badServerResponse)
//        }
//        let finalHTML = resultDataString
        
        // Attempt 2: Render the HTML in the webview
//        let finalHTML = await HTMLRendererAsync().renderHTMLString(resultDataString)
        
        // Attempt 3: Load the request in the webview and retrieve the result
        let finalHTML = await HTMLRendererAsync().renderPage(baseURL: searchURL)
        
        // Decode the data using custom decoder and return
        let decoder = GoogleHTMLDecoder()
        switch type {
        case .text:
            return decoder.decodeTextResults(from: finalHTML)
        case .image:
            return decoder.decodeImageResults(from: finalHTML)
        case .video:
            return decoder.decodeVideoResults(from: finalHTML)
        }
    }
    
    private func getSearchURL(query: String, type: SearchType, startPointer: Int) -> URL? {
        guard var searchURL = GoogleHTMLAPI.search.url else {
            return nil
        }
        
        // Count value must be positibve
        if startPointer >= 0 {
            searchURL = searchURL.appending(queryItems: [URLQueryItem(name: SearchConstants.searchKey, value: query)])
            searchURL = searchURL.appending(queryItems: [URLQueryItem(name: SearchConstants.startPointerKey, value: "\(startPointer)")])
            searchURL = searchURL.appending(queryItems: [URLQueryItem(name: SearchConstants.searchTypeKey, value: "\(type.udm)")])
        }
        
        return searchURL
    }
}
