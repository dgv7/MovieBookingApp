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
        setupSegmentedControl()
        fetchData()
        
                
        displayUserInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBookings), name: Notification.Name("BookingCompleted"), object: nil)
    }
// MARK: - MyPage Edit & Save settings
    private func setupBindings() {
        myPageView.bookingCollectionView.dataSource = self
        myPageView.bookingCollectionView.delegate = self
        myPageView.wantedMoviesCollectionView.dataSource = self
        myPageView.wantedMoviesCollectionView.delegate = self
        
        myPageView.editNameButton.addTarget(self, action: #selector(editName), for: .touchUpInside)
        myPageView.editEmailButton.addTarget(self, action: #selector(editEmail), for: .touchUpInside)
        myPageView.editPasswordButton.addTarget(self, action: #selector(editPassword), for: .touchUpInside)
        myPageView.saveNameButton.addTarget(self, action: #selector(saveName), for: .touchUpInside)
        myPageView.saveEmailButton.addTarget(self, action: #selector(saveEmail), for: .touchUpInside)
        myPageView.savePasswordButton.addTarget(self, action: #selector(savePassword), for: .touchUpInside)
    }
    
    @objc private func editName() {
        myPageView.nameValueLabel.isHidden = true
        myPageView.nameTextField.text = myPageView.nameValueLabel.text
        myPageView.nameTextField.isHidden = false
        myPageView.editNameButton.isHidden = true
        myPageView.saveNameButton.isHidden = false
    }
    
    @objc private func editEmail() {
        myPageView.emailValueLabel.isHidden = true
        myPageView.emailTextField.text = myPageView.emailValueLabel.text
        myPageView.emailTextField.isHidden = false
        myPageView.editEmailButton.isHidden = true
        myPageView.saveEmailButton.isHidden = false
    }
    
    @objc private func editPassword() {
        myPageView.passwordValueLabel.isHidden = true
        myPageView.passwordTextField.text = UserDefaultsManager.shared.getPassword(for: UserDefaultsManager.shared.getEmail()!) ?? ""
        myPageView.passwordTextField.isHidden = false
        myPageView.editPasswordButton.isHidden = true
        myPageView.savePasswordButton.isHidden = false
    }
    
    @objc private func saveName() {
        guard let email = UserDefaultsManager.shared.getEmail() else { return }
        
        let newName = myPageView.nameTextField.text ?? ""
        if newName.isEmpty {
            showAlert(message: "이름을 입력하세요.")
            return
        }
        
        UserDefaultsManager.shared.saveCredentials(email: email, password: UserDefaultsManager.shared.getPassword(for: email) ?? "", nickname: newName, userId: UserDefaultsManager.shared.getUserId(for: email) ?? UUID())
        
        displayUserInfo()
        myPageView.nameTextField.isHidden = true
        myPageView.saveNameButton.isHidden = true
        myPageView.editNameButton.isHidden = false
        myPageView.nameValueLabel.isHidden = false
    }
    
    @objc private func saveEmail() {
        guard let oldEmail = UserDefaultsManager.shared.getEmail() else { return }
        
        let newEmail = myPageView.emailTextField.text ?? oldEmail
        if newEmail.isEmpty {
            showAlert(message: "이메일을 입력하세요.")
            return
        }
        
        let password = UserDefaultsManager.shared.getPassword(for: oldEmail) ?? ""
        let nickname = UserDefaultsManager.shared.getNickname(for: oldEmail) ?? ""
        let userId = UserDefaultsManager.shared.getUserId(for: oldEmail) ?? UUID()
        
        UserDefaultsManager.shared.updateEmail(from: oldEmail, to: newEmail)
        UserDefaultsManager.shared.saveCredentials(email: newEmail, password: password, nickname: nickname, userId: userId)
        
        displayUserInfo()
        myPageView.emailTextField.isHidden = true
        myPageView.saveEmailButton.isHidden = true
        myPageView.editEmailButton.isHidden = false
        myPageView.emailValueLabel.isHidden = false
    }
    
    @objc private func savePassword() {
        guard let email = UserDefaultsManager.shared.getEmail() else { return }
        
        let newPassword = myPageView.passwordTextField.text ?? ""
        if newPassword.isEmpty {
            showAlert(message: "비밀번호를 입력하세요.")
            return
        }
        
        UserDefaultsManager.shared.updatePassword(for: email, to: newPassword)
        
        displayUserInfo()
        myPageView.passwordTextField.isHidden = true
        myPageView.savePasswordButton.isHidden = true
        myPageView.editPasswordButton.isHidden = false
        myPageView.passwordValueLabel.isHidden = false
    }
// MARK: - segmented controller
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
// MARK: - fetchData
    private func fetchData() {
        guard let userId = UserDefaultsManager.shared.getCurrentUserId() else { return }
        viewModel.fetchBookedMovies(for: userId) {
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
    
    @objc private func refreshBookings() {
        fetchData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BookingCompleted"), object: nil)
    }
    
    
    
    
    // 로그아웃시 초기화 -> 아직 구현 안됨.. 개발중 -> displayUserInfo과 관련이 있는가?
    func clearUserData() {
        myPageView.emailValueLabel.text = ""
        myPageView.nameValueLabel.text = ""
        // 데이터 초기화
        viewModel.bookedMovies.removeAll()
        viewModel.wantedMovies.removeAll()
        myPageView.bookingCollectionView.reloadData()
        myPageView.wantedMoviesCollectionView.reloadData()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func displayUserInfo() {
        
        if let email = UserDefaultsManager.shared.getEmail(),
           let nickname = UserDefaultsManager.shared.getNickname(for: email) {
            myPageView.emailValueLabel.text = email
            myPageView.nameValueLabel.text = nickname
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
        예매 날짜: \n\(booking.bookingDate)
        예매 인원: \(booking.bookingNum)명
        좌석 번호: \(booking.bookingSeat) 열
        예매 가격: \(formattedPrice)원
        """
        
        let paragraphStyle = NSMutableParagraphStyle()
        // 왼쪽 정렬
        paragraphStyle.alignment = .left
        let attributedMessage = NSAttributedString(string: message, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let alert = UIAlertController(title: "예매 상세 정보", message: message, preferredStyle: .alert)
        let checkSeatsAction = UIAlertAction(title: "좌석 확인", style: .default) { _ in
            self.showSeatCheckView(seats: booking.bookingSeat)
        }
        let cancelAction = UIAlertAction(title: "예매 취소", style: .destructive) { _ in
            self.cancelBooking(booking)
        }
        let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        alert.addAction(checkSeatsAction)
        alert.addAction(cancelAction)
        alert.addAction(closeAction)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showSeatCheckView(seats: String) {
        let seatIndexes = seats.split(separator: ",").compactMap { IndexPath(seatString: String($0.trimmingCharacters(in: .whitespaces))) }
        let seatCheckVC = SeatSelectionViewController(peopleCount: seatIndexes.count, selectedSeats: seatIndexes, isPreviewMode: true)
        self.present(seatCheckVC, animated: true, completion: nil)
    }
    
    private func cancelBooking(_ booking: Booking) {
        UserDefaultsManager.shared.deleteBooking(booking)
        fetchData()
    }
}

//좌석 정보를 인덱스로 변환
extension IndexPath {
    init?(seatString: String) {
        guard seatString.count >= 2 else { return nil }
        let rowLetter = seatString.first!
        let columnString = seatString.dropFirst()
        
        guard let row = rowLetter.asciiValue.map({ Int($0) - 65 }), // 'A'의 ASCII 값은 65입니다.
              let column = Int(columnString).map({ $0 - 1 }) else { return nil } // IndexPath는 0 기반 인덱스입니다.
        
        self.init(item: row * 8 + column, section: 0)
    }
    
    var stringRepresentation: String {
        let row = item / 8
        let column = item % 8
        let rowLetter = String(UnicodeScalar(65 + row)!)
        return "\(rowLetter)\(column + 1)"
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
            } else if collectionView == myPageView.wantedMoviesCollectionView {
                let movie = viewModel.wantedMovies[indexPath.item]
                let detailVC = MovieDetailViewController(movie: movie)
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
}
