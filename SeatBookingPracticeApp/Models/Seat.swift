import Foundation

enum SeatStatus: String, Equatable {
    case available
    case booked
    case selected
}

struct Seat: Equatable {
    let id: String
    let row: String
    let number: Int
    var status: SeatStatus
    let price: Double

    init(row: String, number: Int, status: SeatStatus = .available, price: Double = 15.0) {
        self.id = "\(row)\(number)"
        self.row = row
        self.number = number
        self.status = status
        self.price = price
    }

    var displayName: String {
        return "\(row)\(number)"
    }
}
