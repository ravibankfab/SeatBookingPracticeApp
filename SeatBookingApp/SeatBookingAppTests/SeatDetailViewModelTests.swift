import XCTest
@testable import SeatBookingApp

class SeatDetailViewModelTests: XCTestCase {
    var sut: SeatDetailViewModel!
    var mockService: MockSeatBookingService!
    var mockDelegate: MockSeatDetailViewModelDelegate!
    var testSeat: Seat!

    override func setUp() {
        super.setUp()
        mockService = MockSeatBookingService()
        testSeat = Seat(id: "R1S1", row: 1, number: 1, isBooked: false, seatType: .standard)
        sut = SeatDetailViewModel(seat: testSeat, service: mockService)
        mockDelegate = MockSeatDetailViewModelDelegate()
        sut.delegate = mockDelegate
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockDelegate = nil
        testSeat = nil
        super.tearDown()
    }

    func testViewModelTitle() {
        XCTAssertEqual(sut.seatTitle, "R1S1")
    }

    func testToggleBookingBooks() {
        XCTAssertFalse(sut.isBooked)
        sut.toggleBooking()
        XCTAssertTrue(sut.isBooked)
        XCTAssertEqual(mockDelegate.didUpdateCallCount, 1)
    }

    func testToggleBookingCancels() {
        sut.toggleBooking()
        XCTAssertTrue(sut.isBooked)
        sut.toggleBooking()
        XCTAssertFalse(sut.isBooked)
        XCTAssertEqual(mockDelegate.didUpdateCallCount, 2)
    }

    func testIsBookedReflectsState() {
        XCTAssertFalse(sut.isBooked)
        sut.toggleBooking()
        XCTAssertTrue(sut.isBooked)
    }
}

class MockSeatDetailViewModelDelegate: SeatDetailViewModelDelegate {
    var didUpdateCallCount = 0
    var didFailCallCount = 0
    var lastError: Error?

    func seatDetailViewModelDidUpdate(_ viewModel: SeatDetailViewModel) {
        didUpdateCallCount += 1
    }

    func seatDetailViewModel(_ viewModel: SeatDetailViewModel, didFailWithError error: Error) {
        didFailCallCount += 1
        lastError = error
    }
}
