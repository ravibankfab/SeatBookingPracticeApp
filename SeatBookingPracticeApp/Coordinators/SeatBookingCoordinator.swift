import UIKit

final class SeatBookingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    private weak var listViewModel: SeatListViewModel?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = SeatListViewModel(coordinator: self)
        listViewModel = viewModel
        let viewController = SeatListViewController(viewModel: viewModel)
        viewController.title = "Seat Booking"
        navigationController.pushViewController(viewController, animated: false)
    }

    func showDetail(for seat: Seat) {
        let viewModel = SeatDetailViewModel(seat: seat, coordinator: self)
        let viewController = SeatDetailViewController(viewModel: viewModel)
        viewController.title = "Seat Detail"
        navigationController.pushViewController(viewController, animated: true)
    }

    func bookingConfirmed(seat: Seat) {
        listViewModel?.markSeatAsBooked(seatID: seat.id)
        let alert = UIAlertController(
            title: "Booking Confirmed",
            message: "Seat \(seat.row)\(seat.number) has been booked!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self else { return }
            self.navigationController.popToRootViewController(animated: true)
            if let listVC = self.navigationController.viewControllers.first as? SeatListViewController {
                listVC.reloadSeats()
            }
        })
        navigationController.present(alert, animated: true)
    }
}
