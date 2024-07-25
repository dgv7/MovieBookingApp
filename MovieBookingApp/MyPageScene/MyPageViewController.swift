import UIKit

class MyPageViewController: UIViewController {
    
//    var email: String?
    
    private let myPageView = MyPageView()
    private let viewModel = MyPageViewModel()
    
    let segmentedControl = UISegmentedControl(items: ["List", "Search", "My Page"])
    
    override func loadView() {
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
//        myPageView.bookingCollectionView.delegate = self
//        myPageView.wantedMoviesCollectionView.delegate = self
        myPageView.bookingCollectionView.dataSource = self
        myPageView.wantedMoviesCollectionView.dataSource = self
        fetchData()

        setupSegmentedControl()
        
        displayUserInfo()

    }
    
    private func setupBindings() {
        myPageView.editNameButton.addTarget(self, action: #selector(editName), for: .touchUpInside)
        myPageView.editEmailButton.addTarget(self, action: #selector(editEmail), for: .touchUpInside)
        myPageView.editPasswordButton.addTarget(self, action: #selector(editPassword), for: .touchUpInside)
    }
    
    @objc private func editName() {
        // 이름 편집 로직
    }
    
    @objc private func editEmail() {
        // 이메일 편집 로직
    }
    
    @objc private func editPassword() {
        // 비밀번호 편집 로직
    }
    
    private func fetchData() {
        viewModel.fetchBookedMovies {
            DispatchQueue.main.async {
                self.myPageView.bookingCollectionView.reloadData()
            }
        }
        viewModel.fetchWantedMovies {
            DispatchQueue.main.async {
                self.myPageView.wantedMoviesCollectionView.reloadData()
            }
        }
    }
        
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 2
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
        if let parentVC = parent as? MovieViewController {
            parentVC.segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
            parentVC.updateView()
        }
    }
    
    private func displayUserInfo() {
        if let email = UserDefaultsManager.shared.getEmail(),
           let nickname = UserDefaultsManager.shared.getNickname(for: email) {
            myPageView.emailValueLabel.text = "\(email)"    // 로그인 email을 기준으로한 nickname 값 가져오기
            myPageView.nameValueLabel.text = "\(nickname)님"
        } else {
            myPageView.emailValueLabel.text = "email 값 없음"
            myPageView.nameValueLabel.text = "nickname 값 없음"
        }
    }
    
    private func displayBookings() {
        guard let email = UserDefaultsManager.shared.getEmail() else { return }
        let bookings = UserDefaultsManager.shared.getBookings(for: email)
    }

}


extension MyPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myPageView.bookingCollectionView {
            return viewModel.bookedMovies.count
        } else {
            return viewModel.wantedMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.identifier, for: indexPath) as! MoviePosterCell
        if collectionView == myPageView.bookingCollectionView {
            let booking = viewModel.bookedMovies[indexPath.item]
            cell.configure(with: booking)
        } else {
            let movie = viewModel.wantedMovies[indexPath.item]
            cell.configure(with: movie)
        }
        return cell
    }
}

//extension MyPageViewController: UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == myPageView.bookingCollectionView {
//            let booking = viewModel.bookedMovies[indexPath.item]
//            let detailVC = BookingDetailViewController(booking: booking)
//            navigationController?.pushViewController(detailVC, animated: true)
//        } else {
//            // handle wantedMovies selection if needed
//        }
//    }
//}
