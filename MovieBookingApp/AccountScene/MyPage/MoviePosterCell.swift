////
////  MoviePosterCell.swift
////  MovieBookingApp
////
////  Created by 김동건 on 7/22/24.
////
//
//import UIKit
//
//class MoviePosterCell: UICollectionViewCell {
//    
//    static let identifier = "MoviePosterCell"
//    
//    let posterImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 8
//        return imageView
//    }()
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textAlignment = .center
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupView() {
//        contentView.addSubview(posterImageView)
//        contentView.addSubview(titleLabel)
//        
//        posterImageView.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            posterImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
//            
//            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 4),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//    }
//    
//    func configure(with movie: Movie) {
//        posterImageView.image = UIImage(named: movie.posterName)
//        titleLabel.text = movie.title
//    }
//}
