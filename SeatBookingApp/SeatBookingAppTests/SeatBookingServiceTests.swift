import XCTest
@testable import SeatBookingApp

class SeatBookingServiceTests: XCTestCase {
    var sut: SeatBookingService!

    override func setUp() {
        super.setUp()
        sut = SeatBookingService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchSeatsReturns40Seats() {
        let seats = sut.fetchSeats()
        XCTAssertEqual(seats.count, 40)
    }

    func testBookSeatSuccessfully() throws {
        let seats = sut.fetchSeats()
        let seat = seats[0]
        let bookedSeat = try sut.bookSeat(seat)
        XCTAssertTrue(bookedSeat.isBooked)
        XCTAssertEqual(bookedSeat.id, seat.id)
    }

    func testBookAlreadyBookedSeatThrows() throws {
        let seats = sut.fetchSeats()
        let seat = seats[0]
        _ = try sut.bookSeat(seat)
        XCTAssertThrowsError(try sut.bookSeat(seat)) { error in
            XCTAssertEqual(error as? SeatBookingError, .alreadyBooked)
        }
    }

    func testCancelBookingSuccessfully() throws {
        let seats = sut.fetchSeats()
        let seat = seats[0]
        _ = try sut.bookSeat(seat)
        let cancelledSeat = try sut.cancelBooking(seat)
        XCTAssertFalse(cancelledSeat.isBooked)
        XCTAssertEqual(cancelledSeat.id, seat.id)
    }

    func testCancelNotBookedSeatThrows() {
        let seats = sut.fetchSeats()
        let seat = seats[0]
        XCTAssertThrowsError(try sut.cancelBooking(seat)) { error in
            XCTAssertEqual(error as? SeatBookingError, .notBooked)
        }
    }

    func testSeatDisplayName() {
        let seats = sut.fetchSeats()
        let seat = seats[0]
        XCTAssertEqual(seat.displayName, "R1S1")
    }

    func testSeatPrice() {
        let seats = sut.fetchSeats()
        let standardSeat = seats.first { $0.seatType == .standard }!
        let premiumSeat = seats.first { $0.seatType == .premium }!
        let vipSeat = seats.first { $0.seatType == .vip }!

        XCTAssertEqual(standardSeat.price, 10.0)
        XCTAssertEqual(premiumSeat.price, 20.0)
        XCTAssertEqual(vipSeat.price, 50.0)
    }
}
