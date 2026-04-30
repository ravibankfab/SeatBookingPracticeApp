import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow

    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let seatListCoordinator = SeatListCoordinator(
            navigationController: navigationController,
            service: SeatBookingService()
        )
        seatListCoordinator.parentCoordinator = self
        addChild(seatListCoordinator)
        seatListCoordinator.start()
    }

    func childDidFinish(_ coordinator: Coordinator) {
        removeChild(coordinator)
    }
}
