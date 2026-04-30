import Foundation

class SeatBookingService: SeatBookingServiceProtocol {
    private var seats: [Seat] = []

    init() {
        seats = generateSeats()
    }

    private func generateSeats() -> [Seat] {
        var result: [Seat] = []
        for row in 1...5 {
            for number in 1...8 {
                let seatType: Seat.SeatType
                switch number {
                case 1...4: seatType = .standard
                case 5...6: seatType = .premium
                default:    seatType = .vip
                }
                let seat = Seat(
                    id: "R\(row)S\(number)",
                    row: row,
                    number: number,
                    isBooked: false,
                    seatType: seatType
                )
                result.append(seat)
            }
        }
        return result
    }

    func fetchSeats() -> [Seat] {
        return seats
    }

    func bookSeat(_ seat: Seat) throws -> Seat {
        guard let index = seats.firstIndex(where: { $0.id == seat.id }) else {
            throw SeatBookingError.notBooked
        }
        guard !seats[index].isBooked else {
            throw SeatBookingError.alreadyBooked
        }
        seats[index].isBooked = true
        return seats[index]
    }

    func cancelBooking(_ seat: Seat) throws -> Seat {
        guard let index = seats.firstIndex(where: { $0.id == seat.id }) else {
            throw SeatBookingError.notBooked
        }
        guard seats[index].isBooked else {
            throw SeatBookingError.notBooked
        }
        seats[index].isBooked = false
        return seats[index]
    }
}
