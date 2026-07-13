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

    func testFivePageDrugCardNavigatesThroughLearnAndSafety() {
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
        app.buttons["Learn"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["drugCard.pharmacology"].waitForExistence(timeout: 5))
        app.buttons["Safety"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["drugCard.safety"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["Source"].exists)
    }

    func testStandaloneAIGeneratorReachesFieldReviewWithoutSourceStep() {
        let app = XCUIApplication()
        app.launchArguments.append("-mockDrugImport")
        app.launch()
        app.tabBars.buttons["Add"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["capture.screen"].waitForExistence(timeout: 15))
        let generate = app.buttons["capture.generateAI"]
        XCTAssertTrue(generate.waitForExistence(timeout: 15))
        generate.tap()
        let scientific = app.textFields["Scientific name"]
        XCTAssertTrue(scientific.waitForExistence(timeout: 10))
        scientific.tap(); scientific.typeText("Metformin")
        if app.keyboards.buttons["Return"].exists { app.keyboards.buttons["Return"].tap() }
        app.buttons["trustedImport.continue"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["trustedImport.preview"].waitForExistence(timeout: 15))
        XCTAssertTrue(app.staticTexts["Generated with AI"].exists)
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

    func testDeepSeekSaveDoesNotAlsoClearAndPersistsAcrossRelaunch() {
        let app = XCUIApplication()
        app.launch()
        openDeepSeekSettings(in: app)

        let clear = app.buttons["deepSeek.clearKey"]
        XCTAssertTrue(clear.waitForExistence(timeout: 5))
        clear.tap()
        dismissDeepSeekAlert(in: app)

        let field = app.secureTextFields["deepSeek.keyField"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("ui-test-key-1234")
        app.buttons["deepSeek.saveKey"].tap()

        let alert = app.alerts["DeepSeek key"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        XCTAssertTrue(alert.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Saved key")).firstMatch.exists)
        alert.buttons["OK"].tap()
        XCTAssertTrue(app.staticTexts["deepSeek.keyStatus"].label.contains("1234"))

        app.terminate()
        app.launch()
        openDeepSeekSettings(in: app)
        let status = app.staticTexts["deepSeek.keyStatus"]
        XCTAssertTrue(status.waitForExistence(timeout: 5))
        XCTAssertTrue(status.label.contains("1234"))
    }

    private func openDeepSeekSettings(in app: XCUIApplication) {
        app.tabBars.buttons["More"].tap()
        if !app.descendants(matching: .any)["more.dashboard"].waitForExistence(timeout: 2) {
            app.tabBars.buttons["More"].tap()
        }
        let preferences = app.buttons["Practice preferences"]
        XCTAssertTrue(preferences.waitForExistence(timeout: 5))
        preferences.tap()
        XCTAssertTrue(app.descendants(matching: .any)["deepSeek.settings"].waitForExistence(timeout: 5))
    }

    private func dismissDeepSeekAlert(in app: XCUIApplication) {
        let alert = app.alerts["DeepSeek key"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["OK"].tap()
    }

    func testImportChooserAndPreviewUseSelectiveFields() {
        let app = XCUIApplication()
        app.launchArguments.append("-mockDrugImport")
        app.launch()
        app.tabBars.buttons["Add"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["capture.screen"].waitForExistence(timeout: 15))
        let importButton = app.buttons["capture.trustedImport"]
        XCTAssertTrue(importButton.waitForExistence(timeout: 10))
        importButton.tap()
        XCTAssertTrue(app.descendants(matching: .any)["trustedImport.photo"].waitForExistence(timeout: 5))
        app.buttons["trustedImport.confirmIdentity"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["trustedImport.confirm"].waitForExistence(timeout: 5))
        let scientific = app.textFields["Scientific name"]
        XCTAssertTrue(scientific.waitForExistence(timeout: 5))
        scientific.tap()
        scientific.typeText("Mock Drug")
        if app.keyboards.buttons["Return"].exists { app.keyboards.buttons["Return"].tap() }
        app.buttons["trustedImport.continue"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["trustedImport.source"].waitForExistence(timeout: 5))
        let formulation = app.buttons["trustedImport.result.mock-label"]
        XCTAssertTrue(formulation.waitForExistence(timeout: 5))
        formulation.tap()
        XCTAssertTrue(app.descendants(matching: .any)["trustedImport.preview"].waitForExistence(timeout: 10))
        let trade = app.switches["import.field.identity.trade"]
        let scientificField = app.switches["import.field.identity.scientific"]
        XCTAssertEqual(trade.value as? String, "1")
        XCTAssertEqual(scientificField.value as? String, "1")
        scientificField.tap()
        XCTAssertEqual(scientificField.value as? String, "0")
        app.swipeUp()
        let apply = app.descendants(matching: .any)["trustedImport.saveSelected"]
        XCTAssertTrue(apply.waitForExistence(timeout: 5))
        XCTAssertTrue(apply.isEnabled)
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
