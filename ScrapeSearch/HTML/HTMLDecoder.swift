//
//  HTMLDecoder.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-06.
//

import Foundation
import SwiftSoup

/// Decodes HTML to scrape search result data for text, image, and video google search results
struct GoogleHTMLDecoder {

    /// Parses a Google search result HTML string to extract organic SearchResult items.
    /// - Parameter htmlString: The full HTML source from a Google result page.
    /// - Returns: An array of `SearchResult` objects.
    func decodeTextResults(from htmlString: String) -> [SearchResult] {
        do {
            // Parse the HTML string
            let doc: Document = try SwiftSoup.parse(htmlString)
            
            // Find the main search results tag
            guard let searchDiv = try doc.select("div#main").first() else {
                print("No div with id='main' found.")
                return []
            }
            
            // Try to filter out extra sections
            try searchDiv.select("div:has(h2:matches((?i)People also ask|Images|People also search for))").remove()
            
            // Try to Identify each "organic" result block within #main.
            let resultDivs = try searchDiv.select("div.Gx5Zad")

            var results: [SearchResult] = []

            for element in resultDivs {
                // Attempt to find link <a> tag, typically containing site URL & page title
                guard
                    let linkElement = try? element.select("a[href^=/url?").first(),
                    let siteURL = try? linkElement.attr("href"),
                    !siteURL.isEmpty
                else {
                    continue
                }
                
                // We have to grab the site title from a specific div class
                let siteTitle = (try? linkElement.select("div.UPmit").first()?.text()) ?? ""
                
                // Page Title can be found in the first h3 tag
                let pageTitle = (try? linkElement.select("h3").first()?.text()) ?? ""
                
                var pageDescription = ""
                // Attempt to get the body of the result. These classes will change from time to time to this is only for demonstration purposes
                // We want the second div for the description text
                if let resultElements = try? element.select("div.kCrYT"), resultElements.count >= 2 {
                    if let descriptionElements = try? resultElements.select("div.s3v9rd").first() {
                        // Then add main description text
                        if let descriptionElement = try? descriptionElements.text() {
                            pageDescription = descriptionElement
                        }
                    }
                }
                print("Combined text: \(pageDescription)")

                // Ensure we have a description the result to further filter out any false-positives from "Recommended results"
                guard !pageDescription.isEmpty, let cleanedSiteURL = extractURLParam(from: siteURL) else {
                    continue
                }
                
                // Build the SearchResult object
                let searchResult = SearchResult(
                    siteTitle: siteTitle,
                    siteURL: cleanedSiteURL,
                    pageTitle: pageTitle,
                    pageDescription: pageDescription,
                    thumbnailURL: nil
                )

                results.append(searchResult)
            }

            return results
        } catch {
            print("Failed to parse HTML: \(error)")
            return []
        }
    }
    
    /// Parses a Google search result HTML string to extract organic SearchResult items.
    /// - Parameter htmlString: The full HTML source from a Google result page.
    /// - Returns: An array of `SearchResult` objects.
    func decodeImageResults(from htmlString: String) -> [SearchResult] {
        do {
            // Parse the HTML string
            let doc: Document = try SwiftSoup.parse(htmlString)
            
            // Find the main table tag
            guard let searchDiv = try doc.select("table.GpQGbf").first() else {
                print("No main table found.")
                return []
            }

            let resultDivs = try searchDiv.select("table.RntSmf")
            
            var results: [SearchResult] = []

            for element in resultDivs {
                // Attempt to find link <a> tag, typically containing site URL
                guard
                    let linkElement = try? element.select("a[href^=/url?").first(),
                    let siteURL = try? linkElement.attr("href"),
                    !siteURL.isEmpty
                else {
                    continue
                }
                let thumbnailURL = try element.select("img.DS1iW").attr("src")
                let pageTitle = try element.select("span.x3G5ab").first()?.text() ?? ""
                let siteTitle = try element.select("span.F9iS2e").first()?.text() ?? ""
                
                // Ensure we have an image and url in the result to further filter out any false-positives from "Recommended results"
                guard !thumbnailURL.isEmpty, let cleanedSiteURL = extractURLParam(from: siteURL) else {
                    continue
                }
                
                // Build the SearchResult object
                let searchResult = SearchResult(
                    siteTitle: siteTitle,
                    siteURL: cleanedSiteURL,
                    pageTitle: pageTitle,
                    pageDescription: "",
                    thumbnailURL: thumbnailURL
                )

                results.append(searchResult)
            }

            return results
        } catch {
            print("Failed to parse HTML: \(error)")
            return []
        }
    }
    
    /// Parses a Google search result HTML string to extract organic SearchResult items.
    /// - Parameter htmlString: The full HTML source from a Google result page.
    /// - Returns: An array of `SearchResult` objects.
    func decodeVideoResults(from htmlString: String) -> [SearchResult] {
        do {
            // Parse the HTML string
            let doc: Document = try SwiftSoup.parse(htmlString)
            
            // Find the main search results tag
            guard let searchDiv = try doc.select("div#main").first() else {
                print("No div with id='main' found.")
                return []
            }
            
            let resultDivs = try searchDiv.select("div.Gx5Zad")

            var results: [SearchResult] = []

            for element in resultDivs {
                // Attempt to find link <a> tag, typically containing site URL
                guard
                    let linkElement = try? element.select("a[href^=/url?").first(),
                    let siteURL = try? linkElement.attr("href"),
                    !siteURL.isEmpty
                else {
                    continue
                }
                
                // We have to grab the site title from a specific div class
                let siteTitle = (try? linkElement.select("div.UPmit").first()?.text()) ?? ""
                
                // Page Title can be found in the first h3 tag
                let pageTitle = (try? linkElement.select("h3").first()?.text()) ?? ""
                
                let thumbnailURL = try element.select("img.h1hFNe").attr("src")
                
                var pageDescription = ""
                // Attempt to get the body of the result. These classes will change from time to time to this is only for demonstration purposes
                // We want the second div for the description text
                if let resultElements = try? element.select("div.kCrYT"), resultElements.count >= 2 {
                    if let descriptionElements = try? resultElements.select("div.s3v9rd").first() {
                        // Then add main description text
                        if let descriptionElement = try? descriptionElements.text() {
                            pageDescription = descriptionElement
                        }
                    }
                }
                print("Combined text: \(pageDescription)")

                
                // Ensure we have an image and url in the result to further filter out any false-positives from "Recommended results"
                guard !pageTitle.isEmpty, let cleanedSiteURL = extractURLParam(from: siteURL) else {
                    continue
                }
                
                // Build the SearchResult object
                let searchResult = SearchResult(
                    siteTitle: siteTitle,
                    siteURL: cleanedSiteURL,
                    pageTitle: pageTitle,
                    pageDescription: "",
                    thumbnailURL: thumbnailURL
                )

                results.append(searchResult)
            }

            return results
        } catch {
            print("Failed to parse HTML: \(error)")
            return []
        }
    }
    
    /// Extracts the actual URL of the search result from the href attribute of the link
    /// - Parameter link: The url parameter from the HTML.
    /// - Returns: An updated URL as a `String` .
    private func extractURLParam(from link: String) -> String? {
        // 1) Remove the leading "/url?" if present
        let withoutPrefix = link.hasPrefix("/url?")
            ? String(link.dropFirst("/url?".count))
            : link

        // 2) Decode HTML-escaped ampersands (&amp; -> &)
        let decoded = withoutPrefix.replacingOccurrences(of: "&amp;", with: "&")

        // 3) Split into key-value pairs
        let pairs = decoded.components(separatedBy: "&")
        for pair in pairs {
            let keyValue = pair.components(separatedBy: "=")
            guard keyValue.count == 2 else { continue }
            let key = keyValue[0]
            let value = keyValue[1]

            // 4) If we find "url", remove any encoding and return its value
            if key == "url" {
                return value.removingPercentEncoding
            }
        }
        return nil
    }
}
