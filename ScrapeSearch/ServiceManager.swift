//
//  ServiceManager.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-07.
//

import Foundation

class ServiceManager {
    static let shared = ServiceManager()
    
    lazy var networkService: NetworkService = BaseNetworkService()
    lazy var searchService: SearchService = GoogleSearchService(networkService: self.networkService)
    // Use the Sample service for testing the local data
//    lazy var searchService: SearchService = SampleSearchService(networkService: SampleNetworkService())
}
