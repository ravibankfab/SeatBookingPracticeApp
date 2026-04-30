import Foundation

final class SeatDetailViewModel {
    private(set) var seat: Seat
    weak var coordinator: SeatBookingCoordinator?

    init(seat: Seat, coordinator: SeatBookingCoordinator) {
        self.seat = seat
        self.coordinator = coordinator
    }

    var seatTitle: String {
        return "Seat \(seat.displayName)"
    }

    var rowInfo: String {
        return "Row: \(seat.row)"
    }

    var seatNumberInfo: String {
        return "Seat Number: \(seat.number)"
    }

    var priceInfo: String {
        return String(format: "Price: $%.2f", seat.price)
    }

    var statusInfo: String {
        return "Status: \(seat.status.rawValue.capitalized)"
    }

    var isBookable: Bool {
        return seat.status == .available
    }

    func bookSeat() {
        guard isBookable else { return }
        seat.status = .booked
        coordinator?.bookingConfirmed(seat: seat)
    }
}
