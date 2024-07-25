//import UIKit
//
//class SeatCheckViewController: UIViewController {
//    
//    private var selectedSeats: [String]
//    
//    init(selectedSeats: [String]) {
//        self.selectedSeats = selectedSeats
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupViews()
//    }
//    
//    private func setupViews() {
//        let seatsLabel = UILabel()
//        seatsLabel.text = "선택한 좌석"
//        seatsLabel.font = .boldSystemFont(ofSize: 24)
//        seatsLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(seatsLabel)
//        
//        let seatsListLabel = UILabel()
//        seatsListLabel.text = selectedSeats.joined(separator: ", ")
//        seatsListLabel.numberOfLines = 0
//        seatsListLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(seatsListLabel)
//        
//        NSLayoutConstraint.activate([
//            seatsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            seatsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            seatsListLabel.topAnchor.constraint(equalTo: seatsLabel.bottomAnchor, constant: 20),
//            seatsListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            seatsListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//        ])
//    }
//}
