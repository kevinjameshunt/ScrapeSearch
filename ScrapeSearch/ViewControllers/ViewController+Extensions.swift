//
//  ViewController+Extensions.swift
//  ScrapeSearch
//
//  Created by Kevin Hunt on 2025-01-08.
//

import UIKit

extension UIViewController {
    
    func showLoadingOverlay() {
        // If already shown, do nothing
        if let _ = view.viewWithTag(9999) { return }
        
        // 1) Create a semi-transparent overlay
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.tag = 9999
        
        // 2) Create and center an activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = overlay.center
        activityIndicator.startAnimating()
        
        // 3) Add the spinner to the overlay
        overlay.addSubview(activityIndicator)
        
        // 4) Add the overlay to our current view
        view.addSubview(overlay)
    }
    
    func hideLoadingOverlay() {
        // Find and remove any overlay tagged with 9999
        if let overlay = view.viewWithTag(9999) {
            overlay.removeFromSuperview()
        }
    }
}
