//
//  VideoResultsViewController.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-08.
//

import UIKit

// MARK: - Text Results TableViewController
class VideoResultsViewController: UITableViewController {
    public var paginationDelegate: SearchResultsPaginationDelegate?
    private var results: [SearchResult] = []
    private var resultsPointer: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.tableView.register(VideoSearchResultCell.self, forCellReuseIdentifier: VideoSearchResultCell.reuseIdentifier)
    }

    // Basic table data source placeholders
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoSearchResultCell.reuseIdentifier, for: indexPath) as! VideoSearchResultCell
        cell.configure(with: results[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = results[indexPath.row]
        if let url = URL(string: result.siteURL) {
            UIApplication.shared.open(url)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // If user is about to see the last cell in 'results'
       if indexPath.row == results.count - 1 {
           self.resultsPointer += 10
           self.paginationDelegate?.requestNextPageAtPointer(resultsPointer)
       }
   }
}

extension VideoResultsViewController: SearchResultsReceiver {
    func updateWithSearchResults(_ newResults: [SearchResult]) {
        guard !newResults.isEmpty else { return }
        
        // Track the current count
        let oldCount = results.count

        // Append new results
        self.results.append(contentsOf: newResults)

        // Create index paths for the new rows
        let newCount = results.count
        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }

        // Insert the rows, rather than reloading everything
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}
