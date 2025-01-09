//
//  SampleSearchService.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-07.
//

import Foundation

class SampleNetworkService : NetworkService {
    func fetch(url: URL) async throws -> Data {
        do {
            let fileContents = try Data(contentsOf: url)
            return fileContents
        } catch {
            print("Error reading file: \(error)")
            throw URLError(.resourceUnavailable)
        }
    }
}

class SampleSearchService: SearchService{
    enum SampleConstants {
        static let fileExtension = "html"
        static let searchTextPtr = "sample_Text"
        static let searchImagePtr = "sample_Image"
        static let searchVideoPtr = "sample_Video"
    }
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    
    func search(query: String, type: SearchType, startPointer: Int = 0) async throws -> [SearchResult] {
        var fileName = SampleConstants.searchTextPtr
        switch type {
        case .text:
                fileName = SampleConstants.searchTextPtr
        case .image:
                fileName = SampleConstants.searchImagePtr
        case .video:
                fileName = SampleConstants.searchVideoPtr
        }
        
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: SampleConstants.fileExtension) else {
            print("File not found in bundle.")
            throw URLError(.badURL)
        }
        
        // Retrieve the HTML response from the sample server
        let data = try await self.networkService.fetch(url: fileURL)
        guard let fileContents = String(data: data, encoding: .utf8) else {
            throw URLError(.badServerResponse)
        }
        
        // Render the HTML in the webview
        let finalHTML = await HTMLRendererAsync().renderHTMLString(fileContents, baseURL: URL(string: SearchConstants.host))
        
        // Decode the data using custom decoder and return
        switch type {
        case .text:
            return GoogleHTMLDecoder().decodeTextResults(from: finalHTML)
        case .image:
            return GoogleHTMLDecoder().decodeImageResults(from: finalHTML)
        case .video:
            return GoogleHTMLDecoder().decodeVideoResults(from: finalHTML)
        }
    }
}
