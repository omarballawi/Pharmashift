import XCTest

final class PharmaShiftUITests: XCTestCase {
    private func scrollToHittable(_ element: XCUIElement, in app: XCUIApplication, maximumSwipes: Int = 6) {
        for _ in 0..<maximumSwipes {
            if element.isHittable { return }
            app.swipeUp()
        }
    }

    private func centerForTap(_ element: XCUIElement, in app: XCUIApplication, maximumSwipes: Int = 4) {
        scrollToHittable(element, in: app, maximumSwipes: maximumSwipes)
        for _ in 0..<maximumSwipes {
            guard element.exists else { return }
            let frame = element.frame
            let visibleTop = app.frame.minY + 120
            let visibleBottom = app.frame.maxY - 140
            if element.isHittable, frame.minY >= visibleTop, frame.maxY <= visibleBottom { return }
            if frame.midY >= app.frame.midY {
                app.swipeUp()
            } else {
                app.swipeDown()
            }
        }
    }

    private func bringTopicCardIntoView(_ element: XCUIElement, in app: XCUIApplication, maximumDrags: Int = 12) {
        let visibleTop = app.frame.minY + 110
        let visibleBottom = app.frame.maxY - 120

        for _ in 0..<maximumDrags {
            if element.exists {
                let frame = element.frame
                if element.isHittable, frame.minY >= visibleTop, frame.maxY <= visibleBottom { return }
                dragPage(in: app, upward: frame.midY >= app.frame.midY)
            } else {
                // Topic cards begin below the identity and memory-anchor surfaces.
                // A short drag avoids skipping the first row as a full swipe can.
                dragPage(in: app, upward: true)
            }
        }
    }

    private func dragPage(in app: XCUIApplication, upward: Bool) {
        let startY: CGFloat = upward ? 0.76 : 0.34
        let endY: CGFloat = upward ? 0.52 : 0.58
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: startY))
            .press(
                forDuration: 0.05,
                thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: endY))
            )
    }

    private func openManualDrugCapture(in app: XCUIApplication) {
        let add = app.buttons["today.add"]
        XCTAssertTrue(add.waitForExistence(timeout: 5))
        add.tap()
        let manual = app.buttons["addHub.manualDrug"]
        XCTAssertTrue(manual.waitForExistence(timeout: 5))
        manual.tap()
        XCTAssertTrue(app.descendants(matching: .any)["capture.screen"].waitForExistence(timeout: 5))
    }

    private func addDrug(named name: String, in app: XCUIApplication) {
        openManualDrugCapture(in: app)
        let scientific = app.textFields["capture.scientificName"]
        scrollToHittable(scientific, in: app, maximumSwipes: 4)
        scientific.tap()
        scientific.typeText(name)
        if app.keyboards.buttons["Return"].exists { app.keyboards.buttons["Return"].tap() }
        let save = app.buttons["capture.saveOpen"]
        centerForTap(save, in: app, maximumSwipes: 5)
        XCTAssertTrue(save.isEnabled)
        XCTAssertTrue(save.isHittable, "Save control was not centered for tapping. Frame: \(save.frame)")
        save.tap()
        XCTAssertTrue(app.descendants(matching: .any)["drug.overview"].waitForExistence(timeout: 5))
    }

    func testHomeDashboardAndFastCaptureAreReachable() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.descendants(matching: .any)["today.dashboard"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.tabBars.buttons.count, 4)
        openManualDrugCapture(in: app)
        XCTAssertTrue(app.textFields["capture.scientificName"].exists)
    }

    func testOnePageDrugProfileExpandsPharmacologyAndSafety() {
        let app = XCUIApplication()
        app.launch()
        addDrug(named: "Phase Two Test Drug", in: app)

        let pharmacology = app.buttons["drug.topic.pharmacology"]
        bringTopicCardIntoView(pharmacology, in: app)
        XCTAssertTrue(pharmacology.waitForExistence(timeout: 5))
        pharmacology.tap()
        XCTAssertTrue(app.navigationBars["Pharmacology"].waitForExistence(timeout: 5))
        app.navigationBars.buttons.element(boundBy: 0).tap()

        let safety = app.buttons["drug.topic.safety"]
        bringTopicCardIntoView(safety, in: app)
        safety.tap()
        XCTAssertTrue(app.navigationBars["Safety"].waitForExistence(timeout: 5))
    }

    func testEveryDrugTopicPushesOnceAndOneBackReturnsToOverview() {
        let app = XCUIApplication()
        app.launch()
        addDrug(named: "Navigation Test Drug", in: app)

        let topics = [
            (id: "drug.topic.brands", title: "Brands & packages"),
            (id: "drug.topic.uses", title: "Uses"),
            (id: "drug.topic.dosing", title: "Forms & dosing"),
            (id: "drug.topic.safety", title: "Safety"),
            (id: "drug.topic.pharmacology", title: "Pharmacology"),
            (id: "drug.topic.counseling", title: "Counseling & Arabic"),
            (id: "drug.topic.sources", title: "Sources, notes & mastery")
        ]
        for topic in topics {
            let link = app.buttons[topic.id]
            bringTopicCardIntoView(link, in: app)
            XCTAssertTrue(link.waitForExistence(timeout: 5), topic.title)
            XCTAssertTrue(link.isHittable, topic.title)
            link.tap()
            XCTAssertTrue(app.navigationBars[topic.title].waitForExistence(timeout: 5), topic.title)
            app.navigationBars[topic.title].buttons.element(boundBy: 0).tap()
            XCTAssertTrue(app.navigationBars["Navigation Test Drug"].waitForExistence(timeout: 5), topic.title)
        }
    }

    func testStandaloneAIGeneratorReachesFieldReviewWithoutSourceStep() {
        let app = XCUIApplication()
        app.launchArguments.append("-mockDrugImport")
        app.launch()
        app.buttons["today.add"].tap()
        let generator = app.buttons["addHub.aiGenerator"]
        XCTAssertTrue(generator.waitForExistence(timeout: 5))
        generator.tap()
        let scientific = app.textFields["trustedImport.scientificName"]
        XCTAssertTrue(scientific.waitForExistence(timeout: 10))
        scientific.tap(); scientific.typeText("Metformin")
        if app.keyboards.buttons["Return"].exists { app.keyboards.buttons["Return"].tap() }
        let continueButton = app.buttons["trustedImport.continue"]
        scrollToHittable(continueButton, in: app, maximumSwipes: 5)
        continueButton.tap()
        XCTAssertTrue(app.descendants(matching: .any)["trustedImport.preview"].waitForExistence(timeout: 15))
        XCTAssertFalse(app.buttons["Source"].exists)
    }

    func testPhotoLibraryButtonPresentsLibraryInsteadOfCamera() {
        let app = XCUIApplication()
        app.launch()
        openManualDrugCapture(in: app)
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
        app.tabBars.buttons["You"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["you.dashboard"].waitForExistence(timeout: 5))
        let link = app.buttons["Backup & data"]
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
        openAISettings(in: app)

        let clear = app.buttons["deepSeek.clearKey"]
        XCTAssertTrue(clear.waitForExistence(timeout: 5))
        clear.tap()
        dismissAIAlert(in: app)

        let field = app.secureTextFields["deepSeek.keyField"]
        field.tap()
        field.typeText("ui-test-key-1234")
        app.buttons["deepSeek.saveKey"].tap()
        let alert = app.alerts["AI key"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        XCTAssertTrue(alert.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Saved key")).firstMatch.exists)
        alert.buttons["OK"].tap()
        XCTAssertTrue(app.staticTexts["deepSeek.keyStatus"].label.contains("1234"))

        app.terminate()
        app.launch()
        openAISettings(in: app)
        XCTAssertTrue(app.staticTexts["deepSeek.keyStatus"].label.contains("1234"))
    }

    private func openAISettings(in app: XCUIApplication) {
        app.tabBars.buttons["You"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["you.dashboard"].waitForExistence(timeout: 5))
        let preferences = app.buttons["Preferences & AI"]
        XCTAssertTrue(preferences.waitForExistence(timeout: 5))
        preferences.tap()
        XCTAssertTrue(app.descendants(matching: .any)["deepSeek.settings"].waitForExistence(timeout: 5))
    }

    private func dismissAIAlert(in app: XCUIApplication) {
        let alert = app.alerts["AI key"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["OK"].tap()
    }

    func testTrustedImportReachesSourceChooser() {
        let app = XCUIApplication()
        app.launchArguments.append("-mockDrugImport")
        app.launchArguments.append("-mockDrugImportSkipPhoto")
        app.launch()
        app.buttons["today.add"].tap()
        let trusted = app.buttons["addHub.trustedImport"]
        XCTAssertTrue(trusted.waitForExistence(timeout: 5))
        trusted.tap()
        XCTAssertTrue(app.descendants(matching: .any)["trustedImport.confirm"].waitForExistence(timeout: 10))
        let scientific = app.textFields["trustedImport.scientificName"]
        scientific.tap(); scientific.typeText("Mock Drug")
        if app.keyboards.buttons["Return"].exists { app.keyboards.buttons["Return"].tap() }
        let continueButton = app.buttons["trustedImport.continue"]
        scrollToHittable(continueButton, in: app, maximumSwipes: 5)
        continueButton.tap()
        XCTAssertTrue(app.descendants(matching: .any)["trustedImport.source"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["trustedImport.result.mock-label"].waitForExistence(timeout: 5))
    }

    func testGeneratedPreviewAllowsSelectiveFields() {
        let app = XCUIApplication()
        app.launchArguments.append("-mockDrugImport")
        app.launch()
        app.buttons["today.add"].tap()
        app.buttons["addHub.aiGenerator"].tap()
        let scientific = app.textFields["trustedImport.scientificName"]
        XCTAssertTrue(scientific.waitForExistence(timeout: 10))
        scientific.tap(); scientific.typeText("Mock Drug")
        if app.keyboards.buttons["Return"].exists { app.keyboards.buttons["Return"].tap() }
        let continueButton = app.buttons["trustedImport.continue"]
        scrollToHittable(continueButton, in: app, maximumSwipes: 5)
        continueButton.tap()
        XCTAssertTrue(app.descendants(matching: .any)["trustedImport.preview"].waitForExistence(timeout: 15))
        let scientificField = app.switches["import.field.identity.scientific"]
        scrollToHittable(scientificField, in: app)
        XCTAssertEqual(scientificField.value as? String, "1")
        scientificField.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        expectation(for: NSPredicate(format: "value == '0'"), evaluatedWith: scientificField)
        waitForExpectations(timeout: 5)
    }

    func testFocusModeShowsOneActionAndPracticeHasFiveQuestionProgress() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertEqual(app.buttons.matching(identifier: "today.recommendedAction").count, 1)
        app.tabBars.buttons["Practice"].tap()
        let mode = app.buttons["practice.mode.Trade → Scientific"]
        if mode.waitForExistence(timeout: 5) {
            mode.tap()
            XCTAssertTrue(app.descendants(matching: .any)["practice.progress"].waitForExistence(timeout: 5))
            XCTAssertTrue(app.staticTexts["Question 1 of 5"].exists)
        }
    }

    func testManualBrandAndDeletionControlsAreReachable() {
        let app = XCUIApplication()
        app.launch()
        addDrug(named: "Omeprazole", in: app)
        let brands = app.buttons["drug.topic.brands"]
        bringTopicCardIntoView(brands, in: app)
        XCTAssertTrue(brands.isHittable)
        brands.tap()
        app.buttons["brands.add"].tap()
        XCTAssertTrue(app.textFields["brand.name"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["brand.save"].isEnabled)
        app.buttons["Cancel"].tap()
        app.navigationBars["Brands & packages"].buttons.element(boundBy: 0).tap()
        let more = app.buttons["More"]
        XCTAssertTrue(more.waitForExistence(timeout: 5))
        more.tap()
        let deleteProfile = app.buttons["Delete drug profile"]
        XCTAssertTrue(deleteProfile.waitForExistence(timeout: 5))
        deleteProfile.tap()
        XCTAssertTrue(app.buttons["drug.deleteConfirm"].waitForExistence(timeout: 5))
    }
}
