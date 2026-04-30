import XCTest

class SeatBookingUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testSeatListIsVisible() {
        let collectionView = app.collectionViews["seatCollectionView"]
        XCTAssertTrue(collectionView.waitForExistence(timeout: 5))
    }

    func testTapSeatNavigatesToDetail() {
        let collectionView = app.collectionViews["seatCollectionView"]
        XCTAssertTrue(collectionView.waitForExistence(timeout: 5))

        let seat = collectionView.cells["seat_R1S1"]
        XCTAssertTrue(seat.waitForExistence(timeout: 5))
        seat.tap()

        let titleLabel = app.staticTexts["seatTitleLabel"]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 5))
        XCTAssertEqual(titleLabel.label, "R1S1")
    }

    func testBookSeatFromDetail() {
        let collectionView = app.collectionViews["seatCollectionView"]
        XCTAssertTrue(collectionView.waitForExistence(timeout: 5))

        let seat = collectionView.cells["seat_R1S1"]
        XCTAssertTrue(seat.waitForExistence(timeout: 5))
        seat.tap()

        let bookButton = app.buttons["bookButton"]
        XCTAssertTrue(bookButton.waitForExistence(timeout: 5))
        bookButton.tap()

        let cancelButton = app.buttons["cancelButton"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
    }

    func testCancelBookingFromDetail() {
        let collectionView = app.collectionViews["seatCollectionView"]
        XCTAssertTrue(collectionView.waitForExistence(timeout: 5))

        let seat = collectionView.cells["seat_R1S1"]
        XCTAssertTrue(seat.waitForExistence(timeout: 5))
        seat.tap()

        let bookButton = app.buttons["bookButton"]
        XCTAssertTrue(bookButton.waitForExistence(timeout: 5))
        bookButton.tap()

        let cancelButton = app.buttons["cancelButton"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
        cancelButton.tap()

        let bookButtonAgain = app.buttons["bookButton"]
        XCTAssertTrue(bookButtonAgain.waitForExistence(timeout: 5))
    }

    func testNavigateBackFromDetail() {
        let collectionView = app.collectionViews["seatCollectionView"]
        XCTAssertTrue(collectionView.waitForExistence(timeout: 5))

        let seat = collectionView.cells["seat_R1S1"]
        XCTAssertTrue(seat.waitForExistence(timeout: 5))
        seat.tap()

        let titleLabel = app.staticTexts["seatTitleLabel"]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 5))

        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertTrue(collectionView.waitForExistence(timeout: 5))
    }
}
