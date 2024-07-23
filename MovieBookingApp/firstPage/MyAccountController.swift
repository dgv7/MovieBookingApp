//
//  MyAccountController.swift
//  MovieBookingApp
//
//  Created by t2023-m0013 on 7/23/24.
//

import UIKit

class MyAccountController: UIViewController {

    let segmentedControl = UISegmentedControl(items: ["List", "Search", "My Page"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Page"
        view.backgroundColor = .white
        
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func segmentChanged() {
        if let parentVC = parent as? MovieViewController {
            parentVC.segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
            parentVC.updateView()
        }
    }
}
