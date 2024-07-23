//
//  MovieService.swift
//  MovieBookingApp
//
//  Created by 김인규 on 7/22/24.
//

//import UIKit
//
//class CollectionTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    let collectionView: UICollectionView
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
//        collectionView.backgroundColor = .white
//        collectionView.showsHorizontalScrollIndicator = false
//
//        contentView.addSubview(collectionView)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10 // Sample item count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
//        
//        // Sample data for demonstration
//        cell.imageView.image = UIImage(named: "samplePoster") // Replace with actual image
//        cell.titleLabel.text = "Movie Title \(indexPath.item)" // Replace with actual title
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 120, height: 180)
//    }
//}
//
//
//class MovieCollectionViewCell: UICollectionViewCell {
//    let imageView = UIImageView()
//    let titleLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        // Configure the image view
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(imageView)
//
//        // Configure the label
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.systemFont(ofSize: 14)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(titleLabel)
//
//        // Set constraints for the image view and label
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
//
//            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

import UIKit

class CollectionTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let collectionView: UICollectionView
    weak var parentViewController: MovieViewController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false

        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let parentViewController = parentViewController else { return 0 }
        switch collectionView.tag {
        case 0:
            return parentViewController.upcomingMovies.count
        case 1:
            return parentViewController.nowPlayingMovies.count
        case 2:
            return parentViewController.popularMovies.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        guard let parentViewController = parentViewController else { return cell }
        let movie: Movie
        switch collectionView.tag {
        case 0:
            movie = parentViewController.upcomingMovies[indexPath.item]
        case 1:
            movie = parentViewController.nowPlayingMovies[indexPath.item]
        case 2:
            movie = parentViewController.popularMovies[indexPath.item]
        default:
            return cell
        }
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let parentViewController = parentViewController else { return }
        let movie: Movie
        switch collectionView.tag {
        case 0:
            movie = parentViewController.upcomingMovies[indexPath.item]
        case 1:
            movie = parentViewController.nowPlayingMovies[indexPath.item]
        case 2:
            movie = parentViewController.popularMovies[indexPath.item]
        default:
            return
        }
        let detailVC = MovieDetailViewController(movie: movie)
        parentViewController.navigationController?.pushViewController(detailVC, animated: true)
    }
}

class MovieCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Configure the image view
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        // Configure the label
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Set constraints for the image view and label
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
        imageView.load(url: imageUrl)
        titleLabel.text = movie.title
    }
}

extension UIImageView {
    func load(url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
