//
//  MainScreenUITest.swift
//  BikeDashboardUITests
//
//  Created by Mate Granic on 18.06.2024..
//

import XCTest

final class MainScreenUITest: XCTestCase {

    //override func setUpWithError() throws {
    //    // Put setup code here. This method is called before the invocation of each test method in the class.

    //    // In UI tests it is usually best to stop immediately when a failure occurs.
    //    continueAfterFailure = false

    //    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    //}

    //override func tearDownWithError() throws {
    //    // Put teardown code here. This method is called after the invocation of each test method in the class.
    //}

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //Makes it go to the right View
        let mainMenuButton = app.buttons["MainMenuButton"]
        XCTAssertTrue(mainMenuButton.exists)
        mainMenuButton.tap() //The action he will execute, just as if you tapped the screen
        
        //Makes it go to the right View
        let settingNavigationLink = app.buttons["SettingsMenuNavigationLink"]
        XCTAssertTrue(settingNavigationLink.exists)
        settingNavigationLink.tap() //The action he will execute, just as if you tapped the screen
        
        // Use the XCUIElementQuery to locate the title Text
        let settingsScreenDznamicText = app.staticTexts["SettingScreenStaticText"]
        // Check if the title text is visible
        XCTAssertTrue(settingsScreenDznamicText.exists)
    }

    //func testLaunchPerformance() throws {
    //    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
    //        // This measures how long it takes to launch your application.
    //        measure(metrics: [XCTApplicationLaunchMetric()]) {
    //            XCUIApplication().launch()
    //        }
    //    }
    //}
}
