import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let seatBookingCoordinator = SeatBookingCoordinator(navigationController: navigationController)
        addChild(seatBookingCoordinator)
        seatBookingCoordinator.start()
    }
}
