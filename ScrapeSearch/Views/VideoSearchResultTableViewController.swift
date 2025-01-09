//
//  VideoSearchResultTableViewController.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-08.
//

import Foundation
import UIKit

class VideoSearchResultCell: UITableViewCell {

    static let reuseIdentifier = "VideoSearchResultCell"

    // Thumbnail on the left
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Overlay a play icon at the center of the thumbnail
    private let playOverlayImageView: UIImageView = {
        let imageView = UIImageView()
        // SFSymbol for a play button
        imageView.image = UIImage(systemName: "play.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Labels on the right side, stacked vertically
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
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

    private let siteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
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

    // MARK: - Init

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

    // MARK: - Subviews

    private func setupSubviews() {
        contentView.addSubview(thumbnailImageView)
        // Overlay belongs on top of the thumbnail
        thumbnailImageView.addSubview(playOverlayImageView)

        contentView.addSubview(siteTitleLabel)
        contentView.addSubview(siteUrlLabel)
        contentView.addSubview(pageTitleLabel)
        contentView.addSubview(pageDescriptionLabel)
    }

    // MARK: - Layout

    private func setupConstraints() {
        // Thumbnail on the left
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            // Let the cell expand for the tallest label if needed
            thumbnailImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ])

        // Center the play icon on the thumbnail
        NSLayoutConstraint.activate([
            playOverlayImageView.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            playOverlayImageView.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            playOverlayImageView.widthAnchor.constraint(equalToConstant: 24),
            playOverlayImageView.heightAnchor.constraint(equalToConstant: 24),
        ])

        // Site Title (top right)
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            pageTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            pageTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])

        // Site URL (below site title)
        NSLayoutConstraint.activate([
            siteUrlLabel.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 4),
            siteUrlLabel.leadingAnchor.constraint(equalTo: pageTitleLabel.leadingAnchor),
            siteUrlLabel.trailingAnchor.constraint(equalTo: pageTitleLabel.trailingAnchor),
        ])

        // Page Title (below site URL)
        NSLayoutConstraint.activate([
            siteTitleLabel.topAnchor.constraint(equalTo: siteUrlLabel.bottomAnchor, constant: 4),
            siteTitleLabel.leadingAnchor.constraint(equalTo: pageTitleLabel.leadingAnchor),
            siteTitleLabel.trailingAnchor.constraint(equalTo: pageTitleLabel.trailingAnchor),
        ])

        // Page Description (below page title)
        NSLayoutConstraint.activate([
            pageDescriptionLabel.topAnchor.constraint(equalTo: siteTitleLabel.bottomAnchor, constant: 4),
            pageDescriptionLabel.leadingAnchor.constraint(equalTo: siteTitleLabel.leadingAnchor),
            pageDescriptionLabel.trailingAnchor.constraint(equalTo: siteTitleLabel.trailingAnchor),
            pageDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    // MARK: - Configuration

    func configure(with result: SearchResult) {
        siteTitleLabel.text = result.siteTitle
        siteUrlLabel.text = result.siteURL
        pageTitleLabel.text = result.pageTitle
        pageDescriptionLabel.text = result.pageDescription

        // For example only — ideally load asynchronously in production
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
}
