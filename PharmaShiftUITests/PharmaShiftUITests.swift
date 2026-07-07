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

    func testContinuousDrugCardScrollsThroughPharmacologyAndSafety() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Add"].tap()
        let scientific = app.textFields["capture.scientificName"]
        XCTAssertTrue(scientific.waitForExistence(timeout: 5))
        scientific.tap()
        scientific.typeText("Phase Two Test Drug")
        app.swipeUp()
        let save = app.buttons["capture.saveOpen"]
        XCTAssertTrue(save.waitForExistence(timeout: 3))
        save.tap()

        XCTAssertTrue(app.descendants(matching: .any)["drugCard.identity"].waitForExistence(timeout: 5))
        for _ in 0..<4 where !app.descendants(matching: .any)["drugCard.pharmacology"].exists { app.swipeUp() }
        XCTAssertTrue(app.descendants(matching: .any)["drugCard.pharmacology"].exists)
        for _ in 0..<4 where !app.descendants(matching: .any)["drugCard.safety"].exists { app.swipeUp() }
        XCTAssertTrue(app.descendants(matching: .any)["drugCard.safety"].exists)
        XCTAssertFalse(app.buttons["Source"].exists)
    }

    func testPhotoLibraryButtonPresentsLibraryInsteadOfCamera() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Add"].tap()
        let library = app.buttons["capture.photoLibrary"]
        XCTAssertTrue(library.waitForExistence(timeout: 5))
        XCTAssertEqual(library.value as? String, "Not selected")
        library.tap()
        XCTAssertEqual(library.value as? String, "Selected")
        XCTAssertEqual(app.buttons["capture.camera"].value as? String, "Not selected")
    }
}
