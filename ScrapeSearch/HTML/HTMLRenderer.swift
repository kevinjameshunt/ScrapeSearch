//
//  HTMLRenderer.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-08.
//

import WebKit
import UIKit

class HTMLRendererAsync: NSObject, WKNavigationDelegate {
    enum Constants {
        static let customUserAgent = "Mozilla/5.0 (Windows NT 5.1; rv:40.0) Gecko/20100101 Firefox/40.0"
    }
    
    private let webView: WKWebView
    private var continuation: CheckedContinuation<String, Never>?

    override init() {
        // Initialize with a config if needed; otherwise just default.
        self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        super.init()
        self.webView.customUserAgent = Constants.customUserAgent
        self.webView.navigationDelegate = self
    }

    /// Async method: Load raw HTML string, wait for JS to run, then retrieve final HTML.
    /// - Parameters:
    ///   - htmlString: The HTML source code.
    ///   - baseURL: Optional base URL for relative paths in HTML.
    /// - Returns: Final rendered HTML string after JavaScript has executed.
    func renderHTMLString(_ htmlString: String, baseURL: URL? = nil) async -> String {
        // Switch from callback-based to async/await with a continuation.
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            self.webView.loadHTMLString(htmlString, baseURL: baseURL)
        }
    }
    
    /// Async method: Load raw HTML from a URL, wait for JS to run, then retrieve final HTML.
    /// - Parameters:
    ///   - baseURL: base URL for relative paths in HTML.
    /// - Returns: Final rendered HTML string after JavaScript has executed.
    func renderPage(baseURL: URL) async -> String {
        // Switch from callback-based to async/await with a continuation.
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            self.webView.load(URLRequest(url: baseURL))
        }
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Evaluate JavaScript for final rendered HTML
        webView.evaluateJavaScript("document.documentElement.outerHTML") { [weak self] result, error in
            guard let self = self else { return }

            let finalHTML: String
            if let error = error {
                print("JS evaluate error: \(error)")
                // Return empty or some fallback if we prefer
                finalHTML = ""
            } else if let html = result as? String {
                finalHTML = html
            } else {
                finalHTML = ""
            }

            // Resume the continuation with finalHTML
            self.continuation?.resume(returning: finalHTML)
            self.continuation = nil
        }
    }
}

