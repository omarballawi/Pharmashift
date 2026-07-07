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

    func testBackupAndDataFlowIsReachable() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["More"].tap()
        let link = app.buttons["Backup & Data"]
        XCTAssertTrue(link.waitForExistence(timeout: 5))
        link.tap()
        XCTAssertTrue(app.descendants(matching: .any)["backup.screen"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["backup.export.lightweight"].exists)
        XCTAssertTrue(app.buttons["backup.export.complete"].exists)
        XCTAssertTrue(app.buttons["backup.import"].exists)
    }

    func testImportChooserAndPreviewUseSelectiveFields() {
        let app = XCUIApplication()
        app.launchArguments.append("-mockDrugImport")
        app.launch()
        app.tabBars.buttons["Add"].tap()
        let scientific = app.textFields["capture.scientificName"]
        XCTAssertTrue(scientific.waitForExistence(timeout: 5))
        scientific.tap()
        scientific.typeText("Mock Drug")
        app.swipeUp()
        app.buttons["capture.saveOpen"].tap()
        XCTAssertTrue(app.buttons["Edit"].waitForExistence(timeout: 5))
        app.buttons["Edit"].tap()
        let importButton = app.buttons["drugEditor.import"]
        XCTAssertTrue(importButton.waitForExistence(timeout: 5))
        importButton.tap()
        XCTAssertTrue(app.descendants(matching: .any)["import.searchScreen"].waitForExistence(timeout: 5))
        app.buttons["import.search"].tap()
        let formulation = app.buttons["import.result.mock-label"]
        XCTAssertTrue(formulation.waitForExistence(timeout: 5))
        formulation.tap()
        XCTAssertTrue(app.descendants(matching: .any)["import.preview"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.switches["import.field.Trade names"].value as? String, "1")
        XCTAssertEqual(app.switches["import.field.Scientific name"].value as? String, "0")
        XCTAssertTrue(app.buttons["import.apply"].isEnabled)
    }

    func testFocusModeShowsOneActionAndPracticeHasFiveQuestionProgress() {
        let app = XCUIApplication()
        app.launch()
        let focusActions = app.descendants(matching: .button).matching(NSPredicate(format: "identifier BEGINSWITH 'home.focus.'"))
        XCTAssertEqual(focusActions.count, 1)
        app.tabBars.buttons["Practice"].tap()
        let mode = app.buttons["practice.mode.Trade → Scientific"]
        if mode.waitForExistence(timeout: 5) {
            mode.tap()
            XCTAssertTrue(app.descendants(matching: .any)["practice.progress"].waitForExistence(timeout: 5))
            XCTAssertTrue(app.staticTexts["Question 1 of 5"].exists)
        }
    }
}
