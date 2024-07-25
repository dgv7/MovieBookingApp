import UIKit
import SnapKit

class SeatSelectionViewController: UIViewController {
    let seatCollectionView: UICollectionView
    let peopleCount: Int
    var selectedSeats: [IndexPath]
    var onSeatsSelected: (([IndexPath]) -> Void)?
    let screenLabel = UILabel()
    var isPreviewMode: Bool = false
    
    init(peopleCount: Int, selectedSeats: [IndexPath] = [], isPreviewMode: Bool = false, onSeatsSelected: (([IndexPath]) -> Void)? = nil) {
        self.peopleCount = peopleCount
        self.selectedSeats = selectedSeats
        self.onSeatsSelected = onSeatsSelected
        self.isPreviewMode = isPreviewMode
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        seatCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        print(selectedSeats)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        seatCollectionView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        seatCollectionView.delegate = self
        seatCollectionView.dataSource = self
        seatCollectionView.register(SeatCell.self, forCellWithReuseIdentifier: "seatCell")
        view.addSubview(seatCollectionView)
        screenLabel.text = "S C R E E N"
        screenLabel.textAlignment = .center
        screenLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        screenLabel.textColor = .white
        view.addSubview(screenLabel)
        screenLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(40)
        }
        seatCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(screenLabel.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        if !isPreviewMode {
            let doneButton = UIButton()
            doneButton.setTitle("완료", for: .normal)
            doneButton.backgroundColor = .systemBlue
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
            view.addSubview(doneButton)
            doneButton.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
                make.centerX.equalToSuperview()
                make.height.equalTo(50)
                make.width.equalTo(100)
            }
        }
        
        let closeButton = UIButton()
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.width.height.equalTo(40)
        }
    }
    
    @objc func doneButtonTapped() {
        if selectedSeats.count == peopleCount {
            let selectedSeatsString = selectedSeats.map { $0.stringRepresentation }.joined(separator: ",")
            // 저장하는 로직에 selectedSeatsString 사용
            onSeatsSelected?(selectedSeats)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "좌석 수 불일치", message: "선택된 좌석 수와 인원 수가 일치하지 않습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension SeatSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 48
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCell", for: indexPath) as! SeatCell
        let seatNumber = seatNumberForIndexPath(indexPath)
        cell.configure(isSelected: selectedSeats.contains(indexPath), seatNumber: seatNumber)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isPreviewMode else { return }
        if let index = selectedSeats.firstIndex(of: indexPath) {
            selectedSeats.remove(at: index)
        } else {
            selectedSeats.append(indexPath)
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    private func seatNumberForIndexPath(_ indexPath: IndexPath) -> String {
        let row = indexPath.item / 8
        let column = indexPath.item % 8
        let rowLetter = Character(UnicodeScalar(65 + row)!)
        return "\(rowLetter)\(column + 1)"
    }
}
