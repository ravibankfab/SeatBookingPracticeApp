import UIKit

final class SeatDetailViewController: UIViewController {
    private let viewModel: SeatDetailViewModel

    private let seatTitleLabel = UILabel()
    private let rowLabel = UILabel()
    private let seatNumberLabel = UILabel()
    private let priceLabel = UILabel()
    private let statusLabel = UILabel()
    private let bookButton = UIButton(type: .system)

    init(viewModel: SeatDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        seatTitleLabel.font = .boldSystemFont(ofSize: 28)
        seatTitleLabel.textAlignment = .center
        seatTitleLabel.accessibilityIdentifier = "seatTitleLabel"

        rowLabel.font = .systemFont(ofSize: 18)
        rowLabel.accessibilityIdentifier = "rowLabel"

        seatNumberLabel.font = .systemFont(ofSize: 18)
        seatNumberLabel.accessibilityIdentifier = "seatNumberLabel"

        priceLabel.font = .systemFont(ofSize: 18)
        priceLabel.accessibilityIdentifier = "priceLabel"

        statusLabel.font = .systemFont(ofSize: 18)
        statusLabel.accessibilityIdentifier = "statusLabel"

        bookButton.setTitle("Book Seat", for: .normal)
        bookButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        bookButton.backgroundColor = .systemBlue
        bookButton.setTitleColor(.white, for: .normal)
        bookButton.layer.cornerRadius = 12
        bookButton.addTarget(self, action: #selector(bookButtonTapped), for: .touchUpInside)
        bookButton.accessibilityIdentifier = "bookSeatButton"

        let stackView = UIStackView(arrangedSubviews: [
            seatTitleLabel, rowLabel, seatNumberLabel, priceLabel, statusLabel, bookButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            bookButton.widthAnchor.constraint(equalToConstant: 200),
            bookButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configure() {
        seatTitleLabel.text = viewModel.seatTitle
        rowLabel.text = viewModel.rowInfo
        seatNumberLabel.text = viewModel.seatNumberInfo
        priceLabel.text = viewModel.priceInfo
        statusLabel.text = viewModel.statusInfo
        bookButton.isEnabled = viewModel.isBookable
        bookButton.alpha = viewModel.isBookable ? 1.0 : 0.5
    }

    @objc private func bookButtonTapped() {
        viewModel.bookSeat()
    }
}
