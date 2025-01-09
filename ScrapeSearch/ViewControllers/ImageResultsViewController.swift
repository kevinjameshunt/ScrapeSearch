//
//  ImageResultsViewController.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-06.
//

import UIKit

// MARK: - Image Results CollectionViewController
class ImageResultsCollectionViewController: UICollectionViewController {
    public var paginationDelegate: SearchResultsPaginationDelegate?
    private var results: [SearchResult] = []
    private var resultsPointer: Int = 0
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 210)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageSearchResultCell.self, forCellWithReuseIdentifier: ImageSearchResultCell.reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
    }

    // Basic collection data source placeholders
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchResultCell.reuseIdentifier, for: indexPath) as! ImageSearchResultCell
        cell.configure(with: results[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       guard let cell = collectionView.cellForItem(at: indexPath) as? ImageSearchResultCell,
             let tappedImage = cell.currentThumbnail() else {
           return
       }
       showFullscreenOverlay(image: tappedImage)
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // If we're about to show the last cell in 'results'
        if indexPath.item == results.count - 1 {
            self.resultsPointer += 20
            self.paginationDelegate?.requestNextPageAtPointer(resultsPointer)
        }
    }
}

extension ImageResultsCollectionViewController: SearchResultsReceiver {
    func updateWithSearchResults(_ newResults: [SearchResult]) {
        guard !newResults.isEmpty else { return }
        
        // Track the current count
        let oldCount = results.count

        // Append new results
        self.results.append(contentsOf: newResults)

        // Create index paths for the new items
        let newCount = results.count
        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        
        // Insert them
        collectionView.insertItems(at: indexPaths)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageResultsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // Cast to flow layout so we can read its spacing
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 140, height: 210) // fallback
        }

        // The total horizontal padding = left+right insets + spacing between columns
        // We have 2 "gaps" between 3 columns if `minimumInteritemSpacing > 0`.
        let totalHorizontalInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let totalSpacing = flowLayout.minimumInteritemSpacing * 2
        let availableWidth = collectionView.bounds.width - totalHorizontalInsets - totalSpacing
        let itemWidth = floor(availableWidth / 3.0)

        // Make height the same as width for a square cell
        return CGSize(width: itemWidth, height: itemWidth*1.5)
    }
}

// MARK: - Fullscreen overlay
extension ImageResultsCollectionViewController {
    
    func showFullscreenOverlay(image: UIImage) {
        let vc = FullscreenImageViewController(image: image)
        present(vc, animated: true)
    }
}
