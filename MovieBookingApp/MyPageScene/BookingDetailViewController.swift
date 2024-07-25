import UIKit
// 이거 샘플 파일이라 무시하셔도 됩니다
class BookingDetailViewController: UIViewController {
    
    private let booking: Booking
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let bookingDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let bookingNumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let bookingPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let bookingSeatLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    init(booking: Booking) {
        self.booking = booking
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        configure(with: booking)
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [movieTitleLabel, bookingDateLabel, bookingNumLabel, bookingPriceLabel, bookingSeatLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configure(with booking: Booking) {
        movieTitleLabel.text = "영화 제목: \(booking.movieTitle)"
        bookingDateLabel.text = "예매 날짜: \(booking.bookingDate)"
        bookingNumLabel.text = "예매 번호: \(booking.bookingNum)"
        bookingPriceLabel.text = "예매 가격: \(booking.bookingPrice)"
        bookingSeatLabel.text = "좌석 번호: \(booking.bookingSeat)"
    }
}
