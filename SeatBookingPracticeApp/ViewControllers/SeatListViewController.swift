import UIKit

final class SeatListViewController: UIViewController {
    private let viewModel: SeatListViewModel
    private var collectionView: UICollectionView!

    private let cellSize: CGFloat = 50
    private let cellSpacing: CGFloat = 8

    init(viewModel: SeatListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupLegend()
        setupCollectionView()
    }

    private func setupLegend() {
        let legendStack = UIStackView()
        legendStack.axis = .horizontal
        legendStack.spacing = 16
        legendStack.distribution = .equalSpacing
        legendStack.translatesAutoresizingMaskIntoConstraints = false

        let availableItem = legendItem(color: .systemGreen, label: "Available")
        let bookedItem = legendItem(color: .systemRed, label: "Booked")

        legendStack.addArrangedSubview(availableItem)
        legendStack.addArrangedSubview(bookedItem)

        view.addSubview(legendStack)
        NSLayoutConstraint.activate([
            legendStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            legendStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func legendItem(color: UIColor, label: String) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 6

        let colorBox = UIView()
        colorBox.backgroundColor = color
        colorBox.layer.cornerRadius = 4
        colorBox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorBox.widthAnchor.constraint(equalToConstant: 16),
            colorBox.heightAnchor.constraint(equalToConstant: 16)
        ])

        let labelView = UILabel()
        labelView.text = label
        labelView.font = .systemFont(ofSize: 13)

        container.addArrangedSubview(colorBox)
        container.addArrangedSubview(labelView)
        return container
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SeatCell.self, forCellWithReuseIdentifier: SeatCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SeatListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let row = viewModel.uniqueRows[section]
        return viewModel.numberOfSeats(inRow: row)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeatCell.reuseIdentifier, for: indexPath) as! SeatCell
        let seat = viewModel.seat(at: indexPath)
        cell.configure(with: seat)
        return cell
    }
}

extension SeatListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectSeat(at: indexPath)
    }
}

// MARK: - SeatCell

final class SeatCell: UICollectionViewCell {
    static let reuseIdentifier = "SeatCell"

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        layer.cornerRadius = 8
        layer.masksToBounds = true

        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with seat: Seat) {
        label.text = seat.displayName
        label.accessibilityIdentifier = "seatLabel_\(seat.displayName)"
        switch seat.status {
        case .available:
            backgroundColor = .systemGreen
        case .booked:
            backgroundColor = .systemRed
        case .selected:
            backgroundColor = .systemBlue
        }
        accessibilityIdentifier = "seat_\(seat.displayName)"
        isUserInteractionEnabled = seat.status == .available
    }
}
