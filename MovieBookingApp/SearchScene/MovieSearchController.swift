//
//  MovieSearchController.swift
//  MovieBookingApp
//
//  Created by t2023-m0013 on 7/23/24.
//

import UIKit

class MovieSearchController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let segmentedControl = UISegmentedControl(items: ["List", "Search", "My Page"])
    let searchBar = UISearchBar()
    let collectionView: UICollectionView
    
    var allMovies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        view.backgroundColor = .white
        
        setupSegmentedControl()
        setupSearchBar()
        setupCollectionView()
        
        fetchAllMovies()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints{
               $0.centerX.equalToSuperview()
               $0.top.equalToSuperview().offset(105)
               $0.leading.equalToSuperview().offset(16)
               $0.trailing.equalToSuperview().offset(-16)
             }
    }
    
    private func setupSearchBar() {
        
        searchBar.placeholder = "영화를 검색해보세요"
        searchBar.layer.cornerRadius = 20
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.borderStyle = .none
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 0.6
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        searchBar.layer.shadowRadius = 8
        searchBar.layer.masksToBounds = false
        searchBar.layer.shouldRasterize = false
        if let tf = searchBar.value(forKey: "searchField") as? UITextField {
            if let leftView = tf.leftView as? UIImageView {
                leftView.tintColor = .red
            }
        }
        
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func segmentChanged() {
        if let parentVC = parent as? MovieViewController {
            parentVC.segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
            parentVC.updateView()
        }
    }
    
    // MARK: - 이부분은 MovieViewController와 충돌남.. 코드 수정 필요
    private func fetchAllMovies() {
        let apiKey = "a03d4de69feac73d515284c317000504"
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Failed to fetch movies: \(error)")
                return
            }
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                self?.allMovies = response.results
                self?.filteredMovies = response.results
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } catch {
                print("Failed to decode movies: \(error)")
            }
        }.resume()
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = allMovies
        } else {
            filteredMovies = allMovies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = filteredMovies[indexPath.item]
        cell.titleLabel.text = movie.title
        
        // Load image asynchronously
        if let posterPath = movie.posterPath {
            let imageUrlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            if let imageUrl = URL(string: imageUrlString) {
                URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                        }
                    }
                }.resume()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 32) / 2, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let movie = filteredMovies[indexPath.item]
            let detailVC = MovieDetailViewController(movie: movie)
            navigationController?.pushViewController(detailVC, animated: true)
        }
}
