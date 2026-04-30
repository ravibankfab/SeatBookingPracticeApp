import UIKit

class SeatCell: UICollectionViewCell {
    static let reuseIdentifier = "SeatCell"

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        layer.cornerRadius = 4
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 2),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -2)
        ])
    }

    func configure(with seat: Seat) {
        label.text = seat.displayName
        accessibilityIdentifier = "seat_\(seat.displayName)"

        if seat.isBooked {
            backgroundColor = .systemGreen
        } else {
            switch seat.seatType {
            case .standard: backgroundColor = .systemGray
            case .premium:  backgroundColor = .systemYellow
            case .vip:      backgroundColor = .systemRed
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .systemGray
        label.text = nil
        accessibilityIdentifier = nil
    }
}
