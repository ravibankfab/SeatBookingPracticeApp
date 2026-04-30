import UIKit

final class SeatBookingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = SeatListViewModel(coordinator: self)
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
        let alert = UIAlertController(
            title: "Booking Confirmed",
            message: "Seat \(seat.row)\(seat.number) has been booked!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController.popToRootViewController(animated: true)
        })
        navigationController.present(alert, animated: true)
    }
}
