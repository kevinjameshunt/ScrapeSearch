//
//  ViewController.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-06.
//

import UIKit


// MARK: - Main View Controller
class ViewController: UIViewController {
    enum Constants {
        static let pageTitle = "Scrape Search"
        static let searchQueryText = "Enter search query"
        static let searchBtnText = "Search"
    }
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.searchQueryText
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.searchBtnText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let searchTypeSegmentControl: UISegmentedControl = {
        let segmentControlItems = SearchType.allCases.map { $0.textValue }
        let segmentControl = UISegmentedControl(items: segmentControlItems)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()

    private let resultsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Child controllers
    private var textResultsVC: TextResultsViewController?
    private var imageResultsVC: ImageResultsCollectionViewController?
    private var videoResultsVC: VideoResultsViewController?
    private var searchType: SearchType = .text

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = Constants.pageTitle
        
        // Setup subviews
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(searchTypeSegmentControl)
        view.addSubview(resultsView)

        setupConstraints()
        setupActions()

        // Load the default child (Text)
        showTextResults()
    }

    private func setupConstraints() {
        // Search TextField on top-left
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            // Search Button on top-right
            searchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 8),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // Segment Control below text field and button
            searchTypeSegmentControl.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            searchTypeSegmentControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTypeSegmentControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // Results View
            resultsView.topAnchor.constraint(equalTo: searchTypeSegmentControl.bottomAnchor, constant: 8),
            resultsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupActions() {
        // Handle segment control value changes
        searchTypeSegmentControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)

        // Button action to perform search
        searchButton.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
        
        // Listen for changes in the text field
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        self.searchType = SearchType(rawValue: sender.selectedSegmentIndex) ?? .text
        switch self.searchType {
        case .text:
            showTextResults()
        case .image:
            showImageResults()
        case .video:
            showVideoResults()
        }
    }

    @objc private func performSearch(_ sender: UIButton) {
        let query = searchTextField.text ?? ""
        print("Performing search for: \(query)")
        
        Task {
            self.showLoadingOverlay()
            let searchResults: [SearchResult] = try await ServiceManager.shared.searchService.search(query: query, type: self.searchType, startPointer: 0)
            self.hideLoadingOverlay()
            self.processResults(searchResults)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Trim whitespace and check if empty
        let isEmpty = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        searchButton.isEnabled = !isEmpty
    }

    private func processResults(_ results: [SearchResult]) {
        print("Results count: \(results.count)")
        switch self.searchType {
        case .text:
            textResultsVC?.updateWithSearchResults(results)
        case .image:
            imageResultsVC?.updateWithSearchResults(results)
        case .video:
            videoResultsVC?.updateWithSearchResults(results)
        }
    }
    
    // MARK: - Child Controller Embedding
    
    private func showTextResults() {
        removeCurrentChildController()
        let vc = TextResultsViewController()
        textResultsVC = vc
        textResultsVC?.paginationDelegate = self
        addChildController(vc, into: resultsView)
    }

    private func showImageResults() {
        removeCurrentChildController()
        let vc = ImageResultsCollectionViewController()
        imageResultsVC = vc
        imageResultsVC?.paginationDelegate = self
        addChildController(vc, into: resultsView)
    }
    
    private func showVideoResults() {
        removeCurrentChildController()
        let vc = VideoResultsViewController()
        videoResultsVC = vc
        videoResultsVC?.paginationDelegate = self
        addChildController(vc, into: resultsView)
    }

    private func removeCurrentChildController() {
        children.forEach { child in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }

    private func addChildController(_ child: UIViewController, into container: UIView) {
        addChild(child)
        container.addSubview(child.view)
        child.view.frame = container.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.didMove(toParent: self)
    }
}

extension ViewController: SearchResultsPaginationDelegate {
    func requestNextPageAtPointer(_ startPointer: Int) {
        let query = searchTextField.text ?? ""
        print("Performing search for: \(query)")
        Task {
            self.showLoadingOverlay()
            let searchResults: [SearchResult] = try await ServiceManager.shared.searchService.search(query: query, type: self.searchType, startPointer: startPointer)
            self.hideLoadingOverlay()
            self.processResults(searchResults)
        }
    }
}
