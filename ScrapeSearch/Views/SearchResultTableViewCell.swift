//
//  SearchResultTableViewCell.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-07.
//

import Foundation
import UIKit

class TextSearchResultCell: UITableViewCell {

    static let reuseIdentifier = "TextSearchResultCell"

    private let siteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let siteUrlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        contentView.addSubview(siteTitleLabel)
        contentView.addSubview(siteUrlLabel)
        contentView.addSubview(pageTitleLabel)
        contentView.addSubview(pageDescriptionLabel)
        contentView.addSubview(thumbnailImageView)
    }

    private func setupConstraints() {
        // Site Title
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            pageTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            pageTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
        ])

        // Site URL
        NSLayoutConstraint.activate([
            siteUrlLabel.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 4),
            siteUrlLabel.leadingAnchor.constraint(equalTo: pageTitleLabel.leadingAnchor),
            siteUrlLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
        ])

        // Page Title
        NSLayoutConstraint.activate([
            siteTitleLabel.topAnchor.constraint(equalTo: siteUrlLabel.bottomAnchor, constant: 4),
            siteTitleLabel.leadingAnchor.constraint(equalTo: pageTitleLabel.leadingAnchor),
            siteTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
        ])

        // Page Description
        NSLayoutConstraint.activate([
            pageDescriptionLabel.topAnchor.constraint(equalTo: siteTitleLabel.bottomAnchor, constant: 4),
            pageDescriptionLabel.leadingAnchor.constraint(equalTo: pageTitleLabel.leadingAnchor),
            pageDescriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            pageDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    // Configure cell with data
    func configure(with result: SearchResult) {
        siteTitleLabel.text = result.siteTitle
        siteUrlLabel.text = result.siteURL
        pageTitleLabel.text = result.pageTitle
        pageDescriptionLabel.text = result.pageDescription

        // For example only — ideally load with URLSession, etc
        if let urlString = result.thumbnailURL, let url = URL(string: urlString) {
            // Example: synchronous loading (not recommended for production)
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
}
