import UIKit

class SeatDetailViewController: UIViewController {
    private let viewModel: SeatDetailViewModel

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.accessibilityIdentifier = "seatTitleLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let rowLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

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
        viewModel.delegate = self
        updateUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, rowLabel, numberLabel, typeLabel, priceLabel, statusLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            actionButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 200),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func updateUI() {
        title = viewModel.seatTitle
        titleLabel.text = viewModel.seatTitle
        rowLabel.text = viewModel.rowText
        numberLabel.text = viewModel.numberText
        typeLabel.text = "Type: \(viewModel.seatType)"
        priceLabel.text = "Price: \(viewModel.price)"
        statusLabel.text = "Status: \(viewModel.statusText)"
        statusLabel.textColor = viewModel.isBooked ? .systemGreen : .secondaryLabel

        if viewModel.isBooked {
            actionButton.setTitle("Cancel Booking", for: .normal)
            actionButton.accessibilityIdentifier = "cancelButton"
            actionButton.backgroundColor = .systemRed
            actionButton.setTitleColor(.white, for: .normal)
        } else {
            actionButton.setTitle("Book", for: .normal)
            actionButton.accessibilityIdentifier = "bookButton"
            actionButton.backgroundColor = .systemBlue
            actionButton.setTitleColor(.white, for: .normal)
        }
    }

    @objc private func actionButtonTapped() {
        viewModel.toggleBooking()
    }
}

extension SeatDetailViewController: SeatDetailViewModelDelegate {
    func seatDetailViewModelDidUpdate(_ viewModel: SeatDetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
    }

    func seatDetailViewModel(_ viewModel: SeatDetailViewModel, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
