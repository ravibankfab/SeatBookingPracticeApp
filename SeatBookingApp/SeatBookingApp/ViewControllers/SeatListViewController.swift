import UIKit

class SeatListViewController: UIViewController {
    private let viewModel: SeatListViewModel
    private var collectionView: UICollectionView!

    private let numberOfColumns: CGFloat = 8
    private let cellSpacing: CGFloat = 4

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
        viewModel.delegate = self
        viewModel.loadSeats()
    }

    private func setupUI() {
        title = "Seat Booking"
        view.backgroundColor = .systemBackground

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        let availableWidth = UIScreen.main.bounds.width - 16 - (cellSpacing * (numberOfColumns - 1))
        let itemWidth = floor(availableWidth / numberOfColumns)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "seatCollectionView"
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SeatCell.self, forCellWithReuseIdentifier: SeatCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SeatListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.filteredSeats.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredSeats[section].count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SeatCell.reuseIdentifier,
            for: indexPath
        ) as? SeatCell else {
            return UICollectionViewCell()
        }
        let seat = viewModel.filteredSeats[indexPath.section][indexPath.item]
        cell.configure(with: seat)
        return cell
    }
}

extension SeatListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seat = viewModel.filteredSeats[indexPath.section][indexPath.item]
        viewModel.didSelectSeat(seat)
    }
}

extension SeatListViewController: SeatListViewModelDelegate {
    func seatListViewModelDidUpdateSeats(_ viewModel: SeatListViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    func seatListViewModel(_ viewModel: SeatListViewModel, didFailWithError error: Error) {
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
