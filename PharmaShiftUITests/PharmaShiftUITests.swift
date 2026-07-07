import XCTest

final class PharmaShiftUITests: XCTestCase {
    func testHomeDashboardAndFastCaptureAreReachable() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.descendants(matching: .any)["home.dashboard"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.otherElements["safety.banner"].exists)
        app.tabBars.buttons["Add"].tap()
        let scientific = app.textFields["capture.scientificName"]
        XCTAssertTrue(scientific.waitForExistence(timeout: 3))
        scientific.tap()
        scientific.typeText("Metformin")
        XCTAssertTrue(app.buttons["capture.saveOpen"].isEnabled)
    }
}
