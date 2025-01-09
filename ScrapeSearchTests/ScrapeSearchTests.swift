//
//  ScrapeSearchTests.swift
//  ScrapeSearchTests
//
//  Created by Kevin Hunt on 2025-01-06.
//

import XCTest
@testable import ScrapeSearch

final class ScrapeSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSampleService_TextSearch() async throws {
        let sampleNetworkService: NetworkService = SampleNetworkService() as! NetworkService
        let searchService = SampleSearchService(networkService: sampleNetworkService)
        let results = try await searchService.search(query: "titus", type: .text)
        print("testSampleService_TextSearch: results \(results.count)")
        XCTAssertEqual(results.count, 9)
    }

    func testSampleService_ImageSearch() async throws {
        let sampleNetworkService: NetworkService = SampleNetworkService() as! NetworkService
        let searchService = SampleSearchService(networkService: sampleNetworkService)
        let results = try await searchService.search(query: "titus", type: .image)
        print("testSampleService_ImageSearch: results \(results.count)")
        XCTAssertEqual(results.count, 20)
    }
    
    func testSampleService_VideoSearch() async throws {
        let sampleNetworkService: NetworkService = SampleNetworkService() as! NetworkService
        let searchService = SampleSearchService(networkService: sampleNetworkService)
        let results = try await searchService.search(query: "titus", type: .video)
        print("testSampleService_VideoSearch: results \(results.count)")
        XCTAssertEqual(results.count, 10)
    }

    func testSearchService_TextSearch() async throws {
        let sampleNetworkService: NetworkService = SampleNetworkService() as! NetworkService
        let searchService = GoogleSearchService(networkService: sampleNetworkService)
        let results = try await searchService.search(query: "titus", type: .text)
        print("testSearchService_Search: results \(results.count)")
        XCTAssertEqual(results.count, 9)
    }

    func testSearchService_ImageSearch() async throws {
        let sampleNetworkService: NetworkService = SampleNetworkService() as! NetworkService
        let searchService = GoogleSearchService(networkService: sampleNetworkService)
        let results = try await searchService.search(query: "titus", type: .image)
        print("testSearchService_ImageSearch: results \(results.count)")
        XCTAssertEqual(results.count, 20)
    }
    
    func testSearchService_VideoSearch() async throws {
        let sampleNetworkService: NetworkService = SampleNetworkService() as! NetworkService
        let searchService = GoogleSearchService(networkService: sampleNetworkService)
        let results = try await searchService.search(query: "titus", type: .video)
        print("testSearchService_VideoSearch: results \(results.count)")
        XCTAssertEqual(results.count, 10)
    }
}
