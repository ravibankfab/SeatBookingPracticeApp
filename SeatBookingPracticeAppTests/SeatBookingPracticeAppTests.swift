import XCTest
@testable import SeatBookingPracticeApp

final class SeatModelTests: XCTestCase {
    func testSeatInitialization() {
        let seat = Seat(row: "A", number: 1)
        XCTAssertEqual(seat.id, "A1")
        XCTAssertEqual(seat.row, "A")
        XCTAssertEqual(seat.number, 1)
        XCTAssertEqual(seat.status, .available)
        XCTAssertEqual(seat.price, 15.0)
    }

    func testSeatDisplayName() {
        let seat = Seat(row: "B", number: 3)
        XCTAssertEqual(seat.displayName, "B3")
    }

    func testSeatEquality() {
        let seat1 = Seat(row: "A", number: 1)
        let seat2 = Seat(row: "A", number: 1)
        XCTAssertEqual(seat1, seat2)
    }

    func testSeatStatusMutation() {
        var seat = Seat(row: "C", number: 2)
        XCTAssertEqual(seat.status, .available)
        seat.status = .booked
        XCTAssertEqual(seat.status, .booked)
    }
}

final class SeatListViewModelTests: XCTestCase {
    var sut: SeatListViewModel!
    var coordinator: SeatBookingCoordinator!

    override func setUp() {
        super.setUp()
        let navController = UINavigationController()
        coordinator = SeatBookingCoordinator(navigationController: navController)
        sut = SeatListViewModel(coordinator: coordinator)
    }

    override func tearDown() {
        sut = nil
        coordinator = nil
        super.tearDown()
    }

    func testNumberOfSections() {
        XCTAssertEqual(sut.numberOfSections, 5)
    }

    func testUniqueRows() {
        XCTAssertEqual(sut.uniqueRows, ["A", "B", "C", "D", "E"])
    }

    func testNumberOfSeatsPerRow() {
        XCTAssertEqual(sut.numberOfSeats(inRow: "A"), 6)
        XCTAssertEqual(sut.numberOfSeats(inRow: "B"), 6)
    }

    func testSeatAtIndexPath() {
        let indexPath = IndexPath(item: 0, section: 0)
        let seat = sut.seat(at: indexPath)
        XCTAssertEqual(seat.row, "A")
        XCTAssertEqual(seat.number, 1)
    }

    func testBookedSeatsExist() {
        let allSeats = (0..<sut.numberOfSections).flatMap { section -> [Seat] in
            let row = sut.uniqueRows[section]
            return (0..<sut.numberOfSeats(inRow: row)).map { item in
                sut.seat(at: IndexPath(item: item, section: section))
            }
        }
        let bookedSeats = allSeats.filter { $0.status == .booked }
        XCTAssertEqual(bookedSeats.count, 5)
    }

    func testTotalSeatCount() {
        let total = (0..<sut.numberOfSections).reduce(0) { sum, section in
            let row = sut.uniqueRows[section]
            return sum + sut.numberOfSeats(inRow: row)
        }
        XCTAssertEqual(total, 30)
    }

    func testMarkSeatAsBooked() {
        let indexPath = IndexPath(item: 0, section: 0)
        XCTAssertEqual(sut.seat(at: indexPath).status, .available)
        sut.markSeatAsBooked(seatID: "A1")
        XCTAssertEqual(sut.seat(at: indexPath).status, .booked)
    }
}

final class SeatDetailViewModelTests: XCTestCase {
    var sut: SeatDetailViewModel!
    var coordinator: SeatBookingCoordinator!

    override func setUp() {
        super.setUp()
        let navController = UINavigationController()
        coordinator = SeatBookingCoordinator(navigationController: navController)
        let seat = Seat(row: "A", number: 1, status: .available, price: 15.0)
        sut = SeatDetailViewModel(seat: seat, coordinator: coordinator)
    }

    override func tearDown() {
        sut = nil
        coordinator = nil
        super.tearDown()
    }

    func testSeatTitle() {
        XCTAssertEqual(sut.seatTitle, "Seat A1")
    }

    func testRowInfo() {
        XCTAssertEqual(sut.rowInfo, "Row: A")
    }

    func testSeatNumberInfo() {
        XCTAssertEqual(sut.seatNumberInfo, "Seat Number: 1")
    }

    func testPriceInfo() {
        XCTAssertEqual(sut.priceInfo, "Price: $15.00")
    }

    func testStatusInfo() {
        XCTAssertEqual(sut.statusInfo, "Status: Available")
    }

    func testIsBookable_whenAvailable() {
        XCTAssertTrue(sut.isBookable)
    }

    func testIsBookable_whenBooked() {
        let navController = UINavigationController()
        let coord = SeatBookingCoordinator(navigationController: navController)
        let bookedSeat = Seat(row: "B", number: 2, status: .booked)
        let vm = SeatDetailViewModel(seat: bookedSeat, coordinator: coord)
        XCTAssertFalse(vm.isBookable)
    }

    func testBookSeat_changesStatusToBooked() {
        sut.bookSeat()
        XCTAssertEqual(sut.currentStatus, .booked)
    }
}

final class CoordinatorTests: XCTestCase {
    func testAppCoordinatorStartsBookingCoordinator() {
        let navController = UINavigationController()
        let appCoordinator = AppCoordinator(navigationController: navController)
        appCoordinator.start()
        XCTAssertEqual(appCoordinator.childCoordinators.count, 1)
        XCTAssertTrue(appCoordinator.childCoordinators.first is SeatBookingCoordinator)
    }

    func testSeatBookingCoordinatorPushesListVC() {
        let navController = UINavigationController()
        let coordinator = SeatBookingCoordinator(navigationController: navController)
        coordinator.start()
        XCTAssertTrue(navController.viewControllers.first is SeatListViewController)
    }

    func testAddAndRemoveChildCoordinator() {
        let navController = UINavigationController()
        let appCoordinator = AppCoordinator(navigationController: navController)
        let childNavController = UINavigationController()
        let child = SeatBookingCoordinator(navigationController: childNavController)

        appCoordinator.addChild(child)
        XCTAssertEqual(appCoordinator.childCoordinators.count, 1)

        appCoordinator.removeChild(child)
        XCTAssertEqual(appCoordinator.childCoordinators.count, 0)
    }
}
