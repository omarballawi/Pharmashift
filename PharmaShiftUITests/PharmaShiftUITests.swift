import XCTest

final class PharmaShiftUITests: XCTestCase {
    func testSafetyBannerAndFastCaptureAreReachable() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.otherElements["safety.banner"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Capture"].tap()
        let scientific = app.textFields["capture.scientificName"]
        XCTAssertTrue(scientific.waitForExistence(timeout: 3))
        scientific.tap()
        scientific.typeText("Metformin")
        XCTAssertTrue(app.buttons["capture.saveOpen"].isEnabled)
    }
}
