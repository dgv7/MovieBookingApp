//
//  MovieCollectionCell.swift
//  MovieBookingApp
//
//  Created by t2023-m0013 on 7/23/24.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    weak var parentViewController: MovieSearchController?
    
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let parentViewController = parentViewController else { return }
//        let movie : Movie
////        let movie = parentViewController.upcomingMovies[indexPath.item]
//        switch collectionView.tag {
//        case 0:
//            movie = parentViewController.upcomingMovies[indexPath.item]
//        case 1:
//            movie = parentViewController.nowPlayingMovies[indexPath.item]
//        case 2:
//            movie = parentViewController.popularMovies[indexPath.item]
//        case 3:
//            movie = parentViewController.topRatedMovies[indexPath.item]
//        default:
//            return
//        }
//        let detailVC = MovieDetailViewController(movie: movie)
//        parentViewController.navigationController?.pushViewController(detailVC, animated: true)
//    }
    
}
