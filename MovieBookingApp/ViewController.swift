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
    
    let imageView = UIImageView()
    let reserveMoveNameLabel = UILabel()
    
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
        
        dateLabel.text = "날짜"
        dateLabel.font = .boldSystemFont(ofSize: 17)
        view.addSubview(dateLabel)
        
        datePicker.datePickerMode = .date
        view.addSubview(datePicker)
        
        peopleLabel.text = "인원"
        peopleLabel.font = .boldSystemFont(ofSize: 17)
        view.addSubview(peopleLabel)
        
        peopleCountLabel.text = "1"
        view.addSubview(peopleCountLabel)
        
        peopleStepper.minimumValue = 1
        peopleStepper.maximumValue = 10
        peopleStepper.value = 1
        peopleStepper.addTarget(self, action: #selector(peopleStepperChanged), for: .valueChanged)
        view.addSubview(peopleStepper)
        
        totalPriceLabel.text = "총 가격: 10,000원"
        totalPriceLabel.font = .boldSystemFont(ofSize: 20)
        view.addSubview(totalPriceLabel)
        
        payButton.setTitle("결제하기", for: .normal)
        payButton.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        payButton.setTitleColor(.black, for: .normal)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        view.addSubview(payButton)
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
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(reserveMoveNameLabel.snp.bottom).offset(40)
            make.leading.equalTo(view).offset(20)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalTo(dateLabel)
            make.trailing.equalTo(view).offset(-20)
        }
        
        peopleLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(40)
            make.leading.equalTo(view).offset(20)
        }
        
        peopleCountLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleLabel.snp.bottom).offset(10)
            make.leading.equalTo(peopleLabel)
        }
        
        peopleStepper.snp.makeConstraints { make in
            make.top.equalTo(peopleCountLabel.snp.bottom).offset(10)
            make.trailing.equalTo(view).offset(-20)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleStepper.snp.bottom).offset(80)
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
        let alert = UIAlertController(title: "결제 확인", message: "결제를 진행하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.showCompletionAlert()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showCompletionAlert() {
        let completionAlert = UIAlertController(title: "결제 완료", message: "결제가 완료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            // 화면 전환 코드
            let movieViewController = MovieViewController()
            self.navigationController?.popViewController(animated: true)
        }
        completionAlert.addAction(okAction)
        
        present(completionAlert, animated: true, completion: nil)
    }
    
    private func configureUI(with movie: Movie) {
        let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")
        imageView.load(url: imageUrl)
        reserveMoveNameLabel.text = "영화명: \(movie.title)"
    }
}
