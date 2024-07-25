import UIKit
import SnapKit
class SeatCell: UICollectionViewCell {
  let seatLabel = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(seatLabel)
    seatLabel.textAlignment = .center
    seatLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func configure(isSelected: Bool, seatNumber: String) {
    seatLabel.text = seatNumber
    contentView.backgroundColor = isSelected ? .white : .gray
  }
}
