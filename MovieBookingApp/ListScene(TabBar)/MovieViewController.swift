import UIKit

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let segmentedControl = UISegmentedControl(items: ["List", "Search", "My Page"])
    let searchViewController = MovieSearchController()
    let myPageViewController = MyPageViewController()
    
    let tableView = UITableView()
    var upcomingMovies: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "영화 뭐보지?"
        
        view.backgroundColor = .white
        
        // navigationItem 숨기기
        self.navigationItem.hidesBackButton = true
        // rightBarButtonItem 커스텀
        let rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
            rightBarButtonItem.tintColor = .systemGray2  // 색상 변경
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        // backBarButtonItem 커스텀
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black  // 색상 변경
            self.navigationItem.backBarButtonItem = backBarButtonItem
        
        setupSegmentedControl() // Segmented Controller 레이아웃
        setupChildViewControllers() // Segmented Controller 하위 페이지 설정
        updateView()    // Segmented Controller 변경시 페이지 전화
        
        fetchMovies()
        setupTable()
        
        
    }
    @objc func logoutTapped() {
        // 로그아웃 기능 구현할 것인가.. 마이페이지 데이터 값도 초기화되도록 해야함.
       
        // 사용자 데이터 초기화
            myPageViewController.clearUserData()
            UserDefaultsManager.shared.clearUserData()
        
        // 이전 화면으로 이동
        navigationController?.popViewController(animated: true)
    }
    // MARK: - yechan add
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
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
    
    @objc private func segmentChanged() {
        updateView()
        syncSegmentedControl()
    }
    
    func updateView() {
        let index = segmentedControl.selectedSegmentIndex
        tableView.isHidden = index != 0
        searchViewController.view.isHidden = index != 1
        myPageViewController.view.isHidden = index != 2
        
        // 동기화된 선택 인덱스를 각 하위 ViewController로 전달
        syncSegmentedControl()
    }
    
    private func syncSegmentedControl() {
        searchViewController.segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        myPageViewController.segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
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
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        // CollectionCell, TableViewCell을 묶어서 사용
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    // 각 테이블 뷰 셀 안에서 Category별(Upcoming.. etc..) 동시 작업 진행
    private func fetchMovies() {
        // DispatchGroup를 통해 여러 비동기 작업 그룹화
        let group = DispatchGroup()
        
        group.enter()   // 작업 시작. 비동기 네트워크 요청시 enter 호출
        MovieService.shared.fetchMovies(endpoint: "upcoming") { movies in
            self.upcomingMovies = movies ?? []  // 데이터를 self.upcomingMovies에 할당
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
        
        // 모든 그룹 작업 완료시 테이블 뷰 새로고침
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4    // TavleViewCell 갯수
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1    // 행 갯수
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
