//
////  MyPageView.swift
////  MovieBookingApp
////
////  Created by 김동건 on 7/22/24.
////
//
//import UIKit
//
//class MyPageView: UIView {
//    
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "이름"
//        label.setContentHuggingPriority(.required, for: .horizontal)
//        return label
//    }()
//    
//    let emailLabel: UILabel = {
//        let label = UILabel()
//        label.text = "이메일"
//        label.setContentHuggingPriority(.required, for: .horizontal)
//        return label
//    }()
//    
//    let passwordLabel: UILabel = {
//        let label = UILabel()
//        label.text = "비밀번호"
//        label.setContentHuggingPriority(.required, for: .horizontal)
//        return label
//    }()
//    
//    let bookingLabel: UILabel = {
//        let label = UILabel()
//        label.text = "예매 내역"
//        return label
//    }()
//    
//    let wantedMoviesLabel: UILabel = {
//        let label = UILabel()
//        label.text = "보고싶은 영화"
//        return label
//    }()
//    
//    let nameValueLabel: UILabel = {
//        let label = UILabel()
//        label.text = "김동건"
//        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        return label
//    }()
//    
//    let emailValueLabel: UILabel = {
//        let label = UILabel()
//        label.text = "abc@gmail.com"
//        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        return label
//    }()
//    
//    let passwordValueLabel: UILabel = {
//        let label = UILabel()
//        label.text = "********"
//        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        return label
//    }()
//    
//    let editNameButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("✏️", for: .normal)
//        return button
//    }()
//    
//    let editEmailButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("✏️", for: .normal)
//        return button
//    }()
//    
//    let editPasswordButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("✏️", for: .normal)
//        return button
//    }()
//    
//    let collectionViewLayout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: 100, height: 150)
//        layout.minimumInteritemSpacing = 8
//        layout.minimumLineSpacing = 8
//        return layout
//    }()
//    
//    lazy var bookingCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
//        collectionView.backgroundColor = .white
//        collectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.identifier)
//        return collectionView
//    }()
//    
//    lazy var wantedMoviesCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
//        collectionView.backgroundColor = .white
//        collectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.identifier)
//        return collectionView
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
//        backgroundColor = .white
//        
//        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameValueLabel, editNameButton])
//        nameStackView.axis = .horizontal
//        nameStackView.alignment = .center
//        nameStackView.spacing = 8
//        
//        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailValueLabel, editEmailButton])
//        emailStackView.axis = .horizontal
//        emailStackView.alignment = .center
//        emailStackView.spacing = 8
//        
//        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordValueLabel, editPasswordButton])
//        passwordStackView.axis = .horizontal
//        passwordStackView.alignment = .center
//        passwordStackView.spacing = 8
//        
//        let infoStackView = UIStackView(arrangedSubviews: [nameStackView, emailStackView, passwordStackView])
//        infoStackView.axis = .vertical
//        infoStackView.alignment = .leading
//        infoStackView.spacing = 16
//        
//        addSubview(infoStackView)
//        addSubview(bookingLabel)
//        addSubview(bookingCollectionView)
//        addSubview(wantedMoviesLabel)
//        addSubview(wantedMoviesCollectionView)
//        
//        infoStackView.translatesAutoresizingMaskIntoConstraints = false
//        bookingLabel.translatesAutoresizingMaskIntoConstraints = false
//        bookingCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        wantedMoviesLabel.translatesAutoresizingMaskIntoConstraints = false
//        wantedMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            infoStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
//            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            
//            bookingLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 32),
//            bookingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            
//            bookingCollectionView.topAnchor.constraint(equalTo: bookingLabel.bottomAnchor, constant: 8),
//            bookingCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            bookingCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            bookingCollectionView.heightAnchor.constraint(equalToConstant: 150),
//            
//            wantedMoviesLabel.topAnchor.constraint(equalTo: bookingCollectionView.bottomAnchor, constant: 32),
//            wantedMoviesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            
//            wantedMoviesCollectionView.topAnchor.constraint(equalTo: wantedMoviesLabel.bottomAnchor, constant: 8),
//            wantedMoviesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            wantedMoviesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            wantedMoviesCollectionView.heightAnchor.constraint(equalToConstant: 150)
//        ])
//    }
//}
