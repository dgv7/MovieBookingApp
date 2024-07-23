//
//  MovieDetailController.swift
//  MovieBookingApp
//
//  Created by t2023-m0013 on 7/23/24.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movie: Movie

    let imageView = UIImageView()
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    let bookingButton = UIButton()

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        configure(with: movie)
    }

    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        overviewLabel.font = UIFont.systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bookingButton.setTitle("예매하기", for: .normal)
        bookingButton.backgroundColor = .blue
        bookingButton.layer.cornerRadius = 10
        bookingButton.translatesAutoresizingMaskIntoConstraints = false
        bookingButton.addTarget(self, action: #selector(bookingButtonTapped), for: .touchUpInside)

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(bookingButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16),
            
            bookingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            bookingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bookingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configure(with movie: Movie) {
        let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
        imageView.load(url: imageUrl)
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
    }
    
    @objc private func bookingButtonTapped() {
        let bookingVC = ViewController()
        navigationController?.pushViewController(bookingVC, animated: true)
    }
    
}

