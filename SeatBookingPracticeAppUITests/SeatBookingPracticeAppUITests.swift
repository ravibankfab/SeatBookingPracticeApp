import XCTest

final class SeatBookingUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testSeatListScreenIsDisplayed() {
        let navBar = app.navigationBars["Seat Booking"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5))
    }

    func testAvailableSeatNavigatesToDetail() {
        // Find an available seat (green) - A1 is available
        let seatA1 = app.cells["seat_A1"]
        XCTAssertTrue(seatA1.waitForExistence(timeout: 5))
        seatA1.tap()

        let detailNavBar = app.navigationBars["Seat Detail"]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 5))

        let seatTitle = app.staticTexts["seatTitleLabel"]
        XCTAssertTrue(seatTitle.exists)
        XCTAssertEqual(seatTitle.label, "Seat A1")
    }

    func testDetailScreenShowsSeatInfo() {
        let seatA1 = app.cells["seat_A1"]
        XCTAssertTrue(seatA1.waitForExistence(timeout: 5))
        seatA1.tap()

        XCTAssertTrue(app.staticTexts["rowLabel"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["rowLabel"].label, "Row: A")
        XCTAssertEqual(app.staticTexts["seatNumberLabel"].label, "Seat Number: 1")
        XCTAssertEqual(app.staticTexts["priceLabel"].label, "Price: $15.00")
        XCTAssertEqual(app.staticTexts["statusLabel"].label, "Status: Available")
    }

    func testBookSeatButtonExists() {
        let seatA1 = app.cells["seat_A1"]
        XCTAssertTrue(seatA1.waitForExistence(timeout: 5))
        seatA1.tap()

        let bookButton = app.buttons["bookSeatButton"]
        XCTAssertTrue(bookButton.waitForExistence(timeout: 5))
        XCTAssertTrue(bookButton.isEnabled)
    }

    func testBookSeatShowsConfirmation() {
        let seatA1 = app.cells["seat_A1"]
        XCTAssertTrue(seatA1.waitForExistence(timeout: 5))
        seatA1.tap()

        let bookButton = app.buttons["bookSeatButton"]
        XCTAssertTrue(bookButton.waitForExistence(timeout: 5))
        bookButton.tap()

        let alert = app.alerts["Booking Confirmed"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))

        alert.buttons["OK"].tap()
        let navBar = app.navigationBars["Seat Booking"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5))
    }
}
