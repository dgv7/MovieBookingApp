//
//  MoviewViewController.swift
//  MovieBookingApp
//
//  Created by 김인규 on 7/22/24.
//


//import UIKit
//
//class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    let tableView = UITableView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "영화 뭐보지?"
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionTableViewCell")
//        tableView.frame = view.bounds
//        view.addSubview(tableView)
//        
//        // 상위 공간 비울 때 사용
////        tableView.translatesAutoresizingMaskIntoConstraints = false
////               NSLayoutConstraint.activate([
////                   tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
////                   tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
////                   tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
////                   tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
////               ])
//
//    }
//
//       func numberOfSections(in tableView: UITableView) -> Int {
//           return 3
//       }
//
//       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//           return 1
//       }
//
//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
//           cell.collectionView.tag = indexPath.section
//           cell.collectionView.reloadData()
//           return cell
//       }
//
//       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//           return 200
//       }
//
//       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//           switch section {
//           case 0:
//               return "Upcoming"
//           case 1:
//               return "Now Playing"
//           case 2:
//               return "Popular"
//           default:
//               return nil
//           }
//       }
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//          if let header = view as? UITableViewHeaderFooterView {
//              header.textLabel?.font = UIFont.boldSystemFont(ofSize: 24) // Customize the font size
//              header.textLabel?.textColor = .black // Customize the text color
//          }
//      }
//
//      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//          return 44
//      }
//    
//   }


import UIKit

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let segmentedControl = UISegmentedControl(items: ["List", "Search", "My Page"])
    let searchViewController = MovieSearchController()
    let myPageViewController = MyAccountController()

    let tableView = UITableView()
    var upcomingMovies: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "영화 뭐보지?"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.frame = view.bounds
        view.addSubview(tableView)

        fetchMovies()
        
        setupSegmentedControl()
        setupChildViewControllers()
        setupTableView()
        
        updateView()
    }
// MARK: - yechan add
    private func setupSegmentedControl() {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(segmentedControl)
            
            NSLayoutConstraint.activate([
                segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//                segmentedControl.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -50),
                segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        }
        
        private func setupChildViewControllers() {
            addChild(searchViewController)
            addChild(myPageViewController)
            
            searchViewController.view.frame = view.bounds
            myPageViewController.view.frame = view.bounds
            
            view.addSubview(searchViewController.view)
            view.addSubview(myPageViewController.view)
            
            searchViewController.didMove(toParent: self)
            myPageViewController.didMove(toParent: self)
            
            searchViewController.view.isHidden = true
            myPageViewController.view.isHidden = true
        }
        
        private func setupTableView() {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionTableViewCell")
            tableView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tableView)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        @objc private func segmentChanged() {
            updateView()
            syncSegmentedControl()
        }
        
        func updateView() {
            let index = segmentedControl.selectedSegmentIndex
            tableView.isHidden = index != 0
            searchViewController.view.isHidden = index != 1
            myPageViewController.view.isHidden = index != 2
        }
        
        private func syncSegmentedControl() {
            searchViewController.segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
            myPageViewController.segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        }

    private func fetchMovies() {
        let group = DispatchGroup()

        group.enter()
        MovieService.shared.fetchMovies(endpoint: "upcoming") { movies in
            self.upcomingMovies = movies ?? []
            group.leave()
        }

        group.enter()
        MovieService.shared.fetchMovies(endpoint: "now_playing") { movies in
            self.nowPlayingMovies = movies ?? []
            group.leave()
        }

        group.enter()
        MovieService.shared.fetchMovies(endpoint: "popular") { movies in
            self.popularMovies = movies ?? []
            group.leave()
        }
        
        group.enter()
        MovieService.shared.fetchMovies(endpoint: "top_rated") { movies in
            self.topRatedMovies = movies ?? []
            group.leave()
        }

        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
        cell.collectionView.tag = indexPath.section
        cell.collectionView.reloadData()
        cell.parentViewController = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Upcoming"
        case 1:
            return "Now Playing"
        case 2:
            return "Popular"
        case 3:
            return "Top Rated"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            header.textLabel?.textColor = .black
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
