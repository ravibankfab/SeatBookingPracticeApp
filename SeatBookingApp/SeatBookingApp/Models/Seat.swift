import Foundation

struct Seat: Identifiable, Equatable {
    let id: String
    let row: Int
    let number: Int
    var isBooked: Bool
    let seatType: SeatType

    enum SeatType: String, CaseIterable {
        case standard = "Standard"
        case premium = "Premium"
        case vip = "VIP"
    }

    var displayName: String { "R\(row)S\(number)" }

    var price: Double {
        switch seatType {
        case .standard: return 10.0
        case .premium: return 20.0
        case .vip: return 50.0
        }
    }
}
