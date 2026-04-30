import UIKit

class SeatDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: SeatListCoordinator?
    private var seat: Seat
    private let service: SeatBookingServiceProtocol

    init(
        navigationController: UINavigationController,
        seat: Seat,
        service: SeatBookingServiceProtocol
    ) {
        self.navigationController = navigationController
        self.seat = seat
        self.service = service
    }

    func start() {
        let viewModel = SeatDetailViewModel(seat: seat, service: service)
        viewModel.coordinatorDelegate = self
        let viewController = SeatDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
}

extension SeatDetailCoordinator: SeatDetailViewModelCoordinatorDelegate {
    func seatDetailViewModel(_ viewModel: SeatDetailViewModel, didUpdateSeat seat: Seat) {
        self.seat = seat
    }

    func seatDetailViewModelDidFinish(_ viewModel: SeatDetailViewModel) {
        finish()
    }
}
