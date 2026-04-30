import Foundation

enum SeatBookingError: Error, Equatable {
    case alreadyBooked
    case notBooked
}

protocol SeatBookingServiceProtocol: AnyObject {
    func fetchSeats() -> [Seat]
    func bookSeat(_ seat: Seat) throws -> Seat
    func cancelBooking(_ seat: Seat) throws -> Seat
}
