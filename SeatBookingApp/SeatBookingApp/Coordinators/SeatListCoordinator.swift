import UIKit

class SeatListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?
    private let service: SeatBookingServiceProtocol

    init(navigationController: UINavigationController, service: SeatBookingServiceProtocol) {
        self.navigationController = navigationController
        self.service = service
    }

    func start() {
        let viewModel = SeatListViewModel(service: service)
        viewModel.coordinatorDelegate = self
        let viewController = SeatListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }

    func showSeatDetail(for seat: Seat) {
        let coordinator = SeatDetailCoordinator(
            navigationController: navigationController,
            seat: seat,
            service: service
        )
        coordinator.parentCoordinator = self
        addChild(coordinator)
        coordinator.start()
    }

    func childDidFinish(_ coordinator: Coordinator) {
        removeChild(coordinator)
    }
}

extension SeatListCoordinator: SeatListViewModelCoordinatorDelegate {
    func seatListViewModel(_ viewModel: SeatListViewModel, didSelectSeat seat: Seat) {
        showSeatDetail(for: seat)
    }
}
