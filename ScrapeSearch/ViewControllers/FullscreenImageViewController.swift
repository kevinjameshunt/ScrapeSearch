//
//  FullscreenImageViewController.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-08.
//

import UIKit
import Photos

class FullscreenImageViewController: UIViewController {

    private let image: UIImage

    // MARK: - Init
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        // Create & constrain the main imageView
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor)
        ])

        // Tap anywhere outside the button to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        view.addGestureRecognizer(tapGesture)

        // Create & constrain the Save button at bottom-center
        let saveButton = UIButton(type: .system)
        saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        saveButton.tintColor = .white
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        // Add target for saving the image
        saveButton.addTarget(self, action: #selector(saveImageToPhotos), for: .touchUpInside)

        // Important: so tap on the button won't also dismiss
        tapGesture.require(toFail: saveButton.gestureRecognizers?.first ?? tapGesture)

        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Actions
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    @objc private func saveImageToPhotos() {
        // For iOS 14+ you can specify .readWrite or .addOnly
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            switch status {
            case .authorized, .limited:
                print("Access granted.")
                // Proceed with reading or writing photos
                self?.saveCurrentImage()
            case .denied, .restricted:
                print("User denied or cannot grant permission.")
            case .notDetermined:
                print("Permission not determined yet.")
            @unknown default:
                print("Unknown authorization status.")
            }
        }
    }
    
    private func saveCurrentImage() {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func saveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alertTitle: String
        let alertMessage: String

        if let error = error {
            alertTitle = "Error"
            alertMessage = "Could not save photo: \(error.localizedDescription)"
        } else {
            alertTitle = "Saved!"
            alertMessage = "Photo saved successfully."
        }

        // Create and present an alert
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
