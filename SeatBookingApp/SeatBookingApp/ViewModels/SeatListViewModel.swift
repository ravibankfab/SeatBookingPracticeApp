import Foundation

protocol SeatListViewModelCoordinatorDelegate: AnyObject {
    func seatListViewModel(_ viewModel: SeatListViewModel, didSelectSeat seat: Seat)
}

protocol SeatListViewModelDelegate: AnyObject {
    func seatListViewModelDidUpdateSeats(_ viewModel: SeatListViewModel)
    func seatListViewModel(_ viewModel: SeatListViewModel, didFailWithError error: Error)
}

class SeatListViewModel {
    private let service: SeatBookingServiceProtocol
    private(set) var seats: [Seat] = []

    weak var delegate: SeatListViewModelDelegate?
    weak var coordinatorDelegate: SeatListViewModelCoordinatorDelegate?

    var filteredSeats: [[Seat]] {
        guard !seats.isEmpty else { return [] }
        let rows = seats.map { $0.row }
        let maxRow = rows.max() ?? 0
        return (1...maxRow).map { row in
            seats.filter { $0.row == row }.sorted { $0.number < $1.number }
        }
    }

    init(service: SeatBookingServiceProtocol) {
        self.service = service
    }

    func loadSeats() {
        seats = service.fetchSeats()
        delegate?.seatListViewModelDidUpdateSeats(self)
    }

    func book(seat: Seat) {
        do {
            let updatedSeat = try service.bookSeat(seat)
            if let index = seats.firstIndex(where: { $0.id == updatedSeat.id }) {
                seats[index] = updatedSeat
            }
            delegate?.seatListViewModelDidUpdateSeats(self)
        } catch {
            delegate?.seatListViewModel(self, didFailWithError: error)
        }
    }

    func cancel(seat: Seat) {
        do {
            let updatedSeat = try service.cancelBooking(seat)
            if let index = seats.firstIndex(where: { $0.id == updatedSeat.id }) {
                seats[index] = updatedSeat
            }
            delegate?.seatListViewModelDidUpdateSeats(self)
        } catch {
            delegate?.seatListViewModel(self, didFailWithError: error)
        }
    }

    func didSelectSeat(_ seat: Seat) {
        coordinatorDelegate?.seatListViewModel(self, didSelectSeat: seat)
    }

    func updateSeat(_ seat: Seat) {
        if let index = seats.firstIndex(where: { $0.id == seat.id }) {
            seats[index] = seat
            delegate?.seatListViewModelDidUpdateSeats(self)
        }
    }
}
