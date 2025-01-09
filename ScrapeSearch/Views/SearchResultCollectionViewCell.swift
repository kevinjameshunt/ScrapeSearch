//
//  SearchResultCollectionViewCell.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-07.
//

import Foundation
import UIKit

// MARK: - Cell
class ImageSearchResultCell: UICollectionViewCell {

    static let reuseIdentifier = "ImageSearchResultCell"

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let siteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let siteUrlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Subviews
    private func setupSubviews() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(siteTitleLabel)
        contentView.addSubview(siteUrlLabel)
        contentView.addSubview(pageTitleLabel)
        contentView.addSubview(pageDescriptionLabel)
    }

    // MARK: - Layout
    private func setupConstraints() {
        // Thumbnail on top
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Site Title
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8),
            pageTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            pageTitleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
        ])

        // Site URL
        NSLayoutConstraint.activate([
            siteUrlLabel.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 4),
            siteUrlLabel.leadingAnchor.constraint(equalTo: pageTitleLabel.leadingAnchor),
            siteUrlLabel.trailingAnchor.constraint(equalTo: pageTitleLabel.trailingAnchor),
        ])

        // Page Title
        NSLayoutConstraint.activate([
            siteTitleLabel.topAnchor.constraint(equalTo: siteUrlLabel.bottomAnchor, constant: 4),
            siteTitleLabel.leadingAnchor.constraint(equalTo: pageTitleLabel.leadingAnchor),
            siteTitleLabel.trailingAnchor.constraint(equalTo: pageTitleLabel.trailingAnchor),
        ])

        // Page Description
        NSLayoutConstraint.activate([
            pageDescriptionLabel.topAnchor.constraint(equalTo: siteTitleLabel.bottomAnchor, constant: 4),
            pageDescriptionLabel.leadingAnchor.constraint(equalTo: pageTitleLabel.leadingAnchor),
            pageDescriptionLabel.trailingAnchor.constraint(equalTo: pageTitleLabel.trailingAnchor),
            pageDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    // MARK: - Configuration
    func configure(with result: SearchResult) {
        siteTitleLabel.text = result.siteTitle
        siteUrlLabel.text = result.siteURL
        pageTitleLabel.text = result.pageTitle
        pageDescriptionLabel.text = result.pageDescription

        // For example only — ideally load with URLSession, etc
        if let urlString = result.thumbnailURL, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = image
                    }
                }
            }
        } else {
            thumbnailImageView.image = nil
        }
    }
    
    // Public accessor if we need the thumbnail image from outside
    func currentThumbnail() -> UIImage? {
        return thumbnailImageView.image
    }
}
