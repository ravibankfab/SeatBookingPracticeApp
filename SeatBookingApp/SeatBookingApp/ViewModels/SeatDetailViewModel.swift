import Foundation

protocol SeatDetailViewModelCoordinatorDelegate: AnyObject {
    func seatDetailViewModel(_ viewModel: SeatDetailViewModel, didUpdateSeat seat: Seat)
    func seatDetailViewModelDidFinish(_ viewModel: SeatDetailViewModel)
}

protocol SeatDetailViewModelDelegate: AnyObject {
    func seatDetailViewModelDidUpdate(_ viewModel: SeatDetailViewModel)
    func seatDetailViewModel(_ viewModel: SeatDetailViewModel, didFailWithError error: Error)
}

class SeatDetailViewModel {
    private(set) var seat: Seat
    private let service: SeatBookingServiceProtocol

    weak var delegate: SeatDetailViewModelDelegate?
    weak var coordinatorDelegate: SeatDetailViewModelCoordinatorDelegate?

    var seatTitle: String { seat.displayName }
    var seatType: String { seat.seatType.rawValue }
    var price: String { String(format: "$%.2f", seat.price) }
    var isBooked: Bool { seat.isBooked }
    var statusText: String { seat.isBooked ? "Booked" : "Available" }
    var rowText: String { "Row: \(seat.row)" }
    var numberText: String { "Seat: \(seat.number)" }

    init(seat: Seat, service: SeatBookingServiceProtocol) {
        self.seat = seat
        self.service = service
    }

    func toggleBooking() {
        do {
            let updatedSeat: Seat
            if seat.isBooked {
                updatedSeat = try service.cancelBooking(seat)
            } else {
                updatedSeat = try service.bookSeat(seat)
            }
            seat = updatedSeat
            coordinatorDelegate?.seatDetailViewModel(self, didUpdateSeat: updatedSeat)
            delegate?.seatDetailViewModelDidUpdate(self)
        } catch {
            delegate?.seatDetailViewModel(self, didFailWithError: error)
        }
    }
}
