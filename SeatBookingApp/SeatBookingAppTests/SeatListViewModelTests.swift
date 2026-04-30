import XCTest
@testable import SeatBookingApp

class SeatListViewModelTests: XCTestCase {
    var sut: SeatListViewModel!
    var mockService: MockSeatBookingService!
    var mockDelegate: MockSeatListViewModelDelegate!

    override func setUp() {
        super.setUp()
        mockService = MockSeatBookingService()
        sut = SeatListViewModel(service: mockService)
        mockDelegate = MockSeatListViewModelDelegate()
        sut.delegate = mockDelegate
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testLoadSeatsPopulatesSeats() {
        sut.loadSeats()
        XCTAssertEqual(sut.seats.count, 40)
        XCTAssertTrue(mockDelegate.didUpdateSeatsCallCount > 0)
    }

    func testSeatsOrganizedByRow() {
        sut.loadSeats()
        let rows = sut.filteredSeats
        XCTAssertEqual(rows.count, 5)
        for row in rows {
            XCTAssertEqual(row.count, 8)
        }
    }

    func testBookSeatUpdatesState() throws {
        sut.loadSeats()
        let seat = sut.seats[0]
        sut.book(seat: seat)
        let updatedSeat = sut.seats.first { $0.id == seat.id }
        XCTAssertNotNil(updatedSeat)
        XCTAssertTrue(updatedSeat!.isBooked)
    }

    func testCancelBookingUpdatesState() throws {
        sut.loadSeats()
        var seat = sut.seats[0]
        sut.book(seat: seat)
        seat = sut.seats.first { $0.id == seat.id }!
        sut.cancel(seat: seat)
        let updatedSeat = sut.seats.first { $0.id == seat.id }
        XCTAssertNotNil(updatedSeat)
        XCTAssertFalse(updatedSeat!.isBooked)
    }
}

class MockSeatListViewModelDelegate: SeatListViewModelDelegate {
    var didUpdateSeatsCallCount = 0
    var didFailCallCount = 0
    var lastError: Error?

    func seatListViewModelDidUpdateSeats(_ viewModel: SeatListViewModel) {
        didUpdateSeatsCallCount += 1
    }

    func seatListViewModel(_ viewModel: SeatListViewModel, didFailWithError error: Error) {
        didFailCallCount += 1
        lastError = error
    }
}

class MockSeatBookingService: SeatBookingServiceProtocol {
    private var service = SeatBookingService()

    func fetchSeats() -> [Seat] { service.fetchSeats() }
    func bookSeat(_ seat: Seat) throws -> Seat { try service.bookSeat(seat) }
    func cancelBooking(_ seat: Seat) throws -> Seat { try service.cancelBooking(seat) }
}
