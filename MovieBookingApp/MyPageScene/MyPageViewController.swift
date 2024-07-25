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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BookingCompleted"), object: nil)
    }
    
    private func setupBindings() {
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
        
        UserDefaultsManager.shared.updatePassword(for: email, to: newPassword)
        
        displayUserInfo()
        myPageView.passwordTextField.isHidden = true
        myPageView.savePasswordButton.isHidden = true
        myPageView.editPasswordButton.isHidden = false
        myPageView.passwordValueLabel.isHidden = false
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
