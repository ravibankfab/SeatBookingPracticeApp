import XCTest
@testable import SeatBookingApp

class CoordinatorTests: XCTestCase {
    var navigationController: UINavigationController!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
    }

    override func tearDown() {
        navigationController = nil
        super.tearDown()
    }

    func testAppCoordinatorStartsWithSeatList() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appCoordinator = AppCoordinator(
            navigationController: navigationController,
            window: window
        )
        appCoordinator.start()

        XCTAssertEqual(appCoordinator.childCoordinators.count, 1)
        XCTAssertTrue(appCoordinator.childCoordinators.first is SeatListCoordinator)
    }

    func testSeatListCoordinatorShowsDetail() {
        let service = SeatBookingService()
        let coordinator = SeatListCoordinator(
            navigationController: navigationController,
            service: service
        )
        coordinator.start()

        XCTAssertEqual(coordinator.childCoordinators.count, 0)

        let seat = Seat(id: "R1S1", row: 1, number: 1, isBooked: false, seatType: .standard)
        coordinator.showSeatDetail(for: seat)

        XCTAssertEqual(coordinator.childCoordinators.count, 1)
        XCTAssertTrue(coordinator.childCoordinators.first is SeatDetailCoordinator)
    }
}
