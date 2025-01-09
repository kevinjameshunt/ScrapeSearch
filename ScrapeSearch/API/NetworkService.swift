//
//  NetworkService.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-06.
//

import Foundation

protocol NetworkService {
    func fetch(url: URL) async throws -> Data
}

class BaseNetworkService: NetworkService {
    func fetch(url: URL) async throws -> Data {
        
        let session = URLSession.shared
        do {
            let (data, response) = try await session.data(for: URLRequest(url: url))
            
            // Check HTTP response status
            guard let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200 || httpResponse.statusCode == 202) else {
                print("Error: Invalid response status code")
                throw URLError(.badServerResponse)
            }
            
            return data
            
        } catch let error as URLError where error.code == .notConnectedToInternet {
            print("Error: No internet connection")
            throw error
        } catch {
            print("Error: \(error.localizedDescription)")
            throw error
        }
    }
    
}
