import UIKit

class MyPageViewController: UIViewController {
    
    private let myPageView = MyPageView()
    private let viewModel = MyPageViewModel()
    
    let segmentedControl = UISegmentedControl(items: ["List", "Search", "My Page"])
    
    override func loadView() {
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        myPageView.bookingCollectionView.dataSource = self
        myPageView.bookingCollectionView.delegate = self
        myPageView.wantedMoviesCollectionView.dataSource = self
        fetchData()

        setupSegmentedControl()
        
        displayUserInfo()
        
        // Notification 수신 설정
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBookings), name: Notification.Name("BookingCompleted"), object: nil)
    }
    
    @objc private func refreshBookings() {
        fetchData()
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
        
        segmentedControl.snp.makeConstraints {
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
            myPageView.emailValueLabel.text = "\(email)"
            myPageView.nameValueLabel.text = "\(nickname)님"
        } else {
            myPageView.emailValueLabel.text = "email 값 없음"
            myPageView.nameValueLabel.text = "nickname 값 없음"
        }
    }
    
    private func displayBookingDetails(_ booking: Booking) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        let formattedPrice = numberFormatter.string(from: NSNumber(value: booking.bookingPrice)) ?? "\(booking.bookingPrice)"
        
        let message = """
        영화 제목: \(booking.movieTitle)
        예매 날짜: \(booking.bookingDate)
        예매 번호: \(booking.bookingNum)
        예매 가격: \(formattedPrice)원
        좌석 번호: \(booking.bookingSeat)
        """
        let alert = UIAlertController(title: "예매 상세 정보", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "예매 취소", style: .destructive) { _ in
            self.cancelBooking(booking)
        }
        let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
    }

    private func cancelBooking(_ booking: Booking) {
        UserDefaultsManager.shared.deleteBooking(booking)
        fetchData()
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

extension MyPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == myPageView.bookingCollectionView {
            let booking = viewModel.bookedMovies[indexPath.item]
            displayBookingDetails(booking)
        }
    }
}
