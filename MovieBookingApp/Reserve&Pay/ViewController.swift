import UIKit
import SnapKit

class ViewController: UIViewController {
  var movie: Movie
  let titleLabel = UILabel()
  let dateLabel = UILabel()
  let datePicker = UIDatePicker()
  let peopleLabel = UILabel()
  let peopleCountLabel = UILabel()
  let peopleStepper = UIStepper()
  let totalPriceLabel = UILabel()
  let payButton = UIButton()
  let selectSeatsButton = UIButton() // 좌석 선택 버튼 추가
  let seatsLabel = UILabel() // "좌석" 라벨 추가
  let selectedSeatsLabel = UILabel() // 선택된 좌석 표시 레이블 추가
  let imageView = UIImageView()
  let reserveMoveNameLabel = UILabel()
  // 날짜 및 시간 스택 뷰
  let dateStackView = UIStackView()
  // 인원 스택 뷰
  let peopleStackView = UIStackView()
  // 선택된 좌석 저장을 위한 배열
  var selectedSeats = [IndexPath]() {
    didSet {
      updateSelectedSeatsLabel()
    }
  }
  init(movie: Movie) {
    self.movie = movie
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupViews()
    setupConstraints()
    configureUI(with: movie)
  }
  private func setupViews() {
    imageView.backgroundColor = .black
    imageView.contentMode = .scaleAspectFill
    view.addSubview(imageView)
    reserveMoveNameLabel.textColor = .black
    reserveMoveNameLabel.font = .boldSystemFont(ofSize: 15)
    reserveMoveNameLabel.numberOfLines = 0
    view.addSubview(reserveMoveNameLabel)
    titleLabel.text = "예매하기"
    titleLabel.font = .boldSystemFont(ofSize: 30)
    view.addSubview(titleLabel)
    dateLabel.text = "날짜 및 시간"
    dateLabel.font = .boldSystemFont(ofSize: 17)
    // 날짜 및 시간 스택 뷰 설정
    dateStackView.axis = .horizontal
    dateStackView.spacing = 10
    dateStackView.alignment = .center
    dateStackView.addArrangedSubview(dateLabel)
    dateStackView.addArrangedSubview(datePicker)
    view.addSubview(dateStackView)
    peopleLabel.text = "인원"
    peopleLabel.font = .boldSystemFont(ofSize: 17)
    // 인원 스택 뷰 설정
    peopleStackView.axis = .horizontal
    peopleStackView.spacing = 10
    peopleStackView.alignment = .center
    peopleStackView.addArrangedSubview(peopleLabel)
    peopleStackView.addArrangedSubview(peopleCountLabel)
    peopleStackView.addArrangedSubview(peopleStepper)
    view.addSubview(peopleStackView)
    peopleCountLabel.text = "1"
    peopleStepper.minimumValue = 1
    peopleStepper.maximumValue = 10
    peopleStepper.value = 1
    peopleStepper.addTarget(self, action: #selector(peopleStepperChanged), for: .valueChanged)
    totalPriceLabel.text = "총 가격: 10,000원"
    totalPriceLabel.font = .boldSystemFont(ofSize: 20)
    view.addSubview(totalPriceLabel)
    payButton.setTitle("결제하기", for: .normal)
    payButton.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
    payButton.setTitleColor(.black, for: .normal)
    payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    view.addSubview(payButton)
    // 좌석 선택 버튼 추가
    selectSeatsButton.setTitle("좌석 선택", for: .normal)
    selectSeatsButton.backgroundColor = .systemBlue
    selectSeatsButton.setTitleColor(.white, for: .normal)
    selectSeatsButton.addTarget(self, action: #selector(showSeatSelectionModal), for: .touchUpInside)
    view.addSubview(selectSeatsButton)
    // "좌석" 라벨 추가
    seatsLabel.text = "좌석"
    seatsLabel.font = .boldSystemFont(ofSize: 17)
    view.addSubview(seatsLabel)
    // 선택된 좌석 표시 레이블 추가
    selectedSeatsLabel.text = ""
    selectedSeatsLabel.font = .systemFont(ofSize: 17)
    view.addSubview(selectedSeatsLabel)
  }
  func setupConstraints() {
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.equalTo(view).offset(20)
    }
    imageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(40)
      $0.centerX.equalToSuperview()
      $0.height.width.equalTo(150)
    }
    reserveMoveNameLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(40)
      $0.centerX.equalTo(imageView)
    }
    // 날짜 및 시간 스택 뷰 레이아웃 설정
    dateStackView.snp.makeConstraints { make in
      make.top.equalTo(reserveMoveNameLabel.snp.bottom).offset(40)
      make.leading.trailing.equalTo(view).inset(20)
    }
    // 인원 스택 뷰 레이아웃 설정
    peopleStackView.snp.makeConstraints { make in
      make.top.equalTo(dateStackView.snp.bottom).offset(20)
      make.leading.trailing.equalTo(view).inset(20)
    }
    // "좌석" 라벨 레이아웃 설정
    seatsLabel.snp.makeConstraints { make in
      make.top.equalTo(peopleStackView.snp.bottom).offset(20)
      make.leading.equalTo(view).offset(20)
    }
    // 선택된 좌석 표시 레이블 레이아웃 설정
    selectedSeatsLabel.snp.makeConstraints { make in
      make.trailing.equalTo(view).offset(-30)
      make.centerY.equalTo(seatsLabel)
    }
    // 좌석 선택 버튼 레이아웃 설정
    selectSeatsButton.snp.makeConstraints { make in
      make.top.equalTo(seatsLabel.snp.bottom).offset(20)
      make.leading.trailing.equalTo(view).inset(20)
      make.height.equalTo(50)
    }
    totalPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(selectSeatsButton.snp.bottom).offset(20)
      make.trailing.equalTo(view).offset(-20)
    }
    payButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
      make.leading.equalTo(view)
      make.trailing.equalTo(view)
      make.height.equalTo(50)
    }
  }
  @objc func peopleStepperChanged(_ sender: UIStepper) {
    let count = Int(sender.value)
    peopleCountLabel.text = "\(count)"
    totalPriceLabel.text = "총 가격: \(count * 10000)원"
  }
  @objc func payButtonTapped() {
    if selectedSeats.isEmpty {
      // 좌석이 선택되지 않은 경우
      let alert = UIAlertController(title: "좌석 선택 필요", message: "좌석을 선택하십시오.", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
    } else {
      // 좌석이 선택된 경우 결제 확인 알림 표시
      let alert = UIAlertController(title: "결제 확인", message: "결제를 진행하시겠습니까?", preferredStyle: .alert)
      let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
        self.showCompletionAlert()
      }
      let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
      alert.addAction(confirmAction)
      alert.addAction(cancelAction)
      present(alert, animated: true, completion: nil)
    }
  }
  @objc func showSeatSelectionModal() {
    let peopleCount = Int(peopleStepper.value)
    let seatSelectionVC = SeatSelectionViewController(peopleCount: peopleCount) { [weak self] selectedSeats in
      if selectedSeats.count == peopleCount {
        // 인원 수와 선택된 좌석 수가 일치하는 경우
        self?.selectedSeats = selectedSeats
      } else {
        // 인원 수와 선택된 좌석 수가 일치하지 않는 경우
        let alert = UIAlertController(title: "좌석 수 불일치", message: "선택된 좌석 수와 인원 수가 일치하지 않습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self?.present(alert, animated: true, completion: nil)
      }
    }
    seatSelectionVC.modalPresentationStyle = .overFullScreen
    seatSelectionVC.modalTransitionStyle = .crossDissolve
    present(seatSelectionVC, animated: true, completion: nil)
  }
  func showCompletionAlert() {
    let completionAlert = UIAlertController(title: "결제 완료", message: "결제가 완료되었습니다.", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
      // 화면 전환 코드
      _ = MovieViewController()
      self.navigationController?.popViewController(animated: true)
    }
    completionAlert.addAction(okAction)
    present(completionAlert, animated: true, completion: nil)
  }
  private func configureUI(with movie: Movie) {
    let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")
    imageView.setImage(from: imageUrl)
    reserveMoveNameLabel.text = "영화명: \(movie.title)"
  }
  private func updateSelectedSeatsLabel() {
    let seatNumbers = selectedSeats.map { seatNumberForIndexPath($0) }
    selectedSeatsLabel.text = seatNumbers.joined(separator: ", ")
  }
  private func seatNumberForIndexPath(_ indexPath: IndexPath) -> String {
    let row = indexPath.item / 8
    let column = indexPath.item % 8
    let rowLetter = Character(UnicodeScalar(65 + row)!)
    return "\(rowLetter)\(column + 1)"
  }
}
extension UIImageView {
  func setImage(from url: URL?) {
    guard let url = url else { return }
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
    }
  }
}
