import Foundation

final class SeatListViewModel {
    private(set) var seats: [Seat]
    weak var coordinator: SeatBookingCoordinator?

    init(coordinator: SeatBookingCoordinator) {
        self.coordinator = coordinator
        self.seats = SeatListViewModel.generateSeats()
    }

    var numberOfSections: Int {
        return uniqueRows.count
    }

    var uniqueRows: [String] {
        var seen = Set<String>()
        return seats.map { $0.row }.filter { seen.insert($0).inserted }
    }

    func numberOfSeats(inRow row: String) -> Int {
        return seats.filter { $0.row == row }.count
    }

    func seat(at indexPath: IndexPath) -> Seat {
        let row = uniqueRows[indexPath.section]
        let seatsInRow = seats.filter { $0.row == row }
        return seatsInRow[indexPath.item]
    }

    func selectSeat(at indexPath: IndexPath) {
        let seat = seat(at: indexPath)
        if seat.status == .available {
            coordinator?.showDetail(for: seat)
        }
    }

    private static func generateSeats() -> [Seat] {
        let rows = ["A", "B", "C", "D", "E"]
        let seatsPerRow = 6
        var seats: [Seat] = []
        let bookedSeats: Set<String> = ["A2", "B4", "C1", "D3", "E5"]

        for row in rows {
            for number in 1...seatsPerRow {
                let id = "\(row)\(number)"
                let status: SeatStatus = bookedSeats.contains(id) ? .booked : .available
                seats.append(Seat(row: row, number: number, status: status))
            }
        }
        return seats
    }
}
