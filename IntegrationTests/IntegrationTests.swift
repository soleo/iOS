//
//  IntegrationTests.swift
//  IntegrationTests
//
//  Created by duckduckgo on 07/09/2017.
//  Copyright © 2017 DuckDuckGo. All rights reserved.
//

import XCTest

class IntegrationTests: XCTestCase {
    
    struct PageElementIndex {
        static let uniqueTrackerCount: UInt = 2
    }
    
    var app: XCUIApplication!
    
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
        
        skipOnboarding()
        clearTabsAndData()
        
        continueAfterFailure = true
    }
    
    func testThatNothingIsBlockedOnCleanPage() {
        runTestPage(pageUrl: "http://localhost:8000/notrackers.html")
    }

    func testThatIFramesAreBlocked() {
        runTestPage(pageUrl: "http://localhost:8000/iframetrackers.html")
    }
    
    func testThatResourcesAreBlocked() {
        runTestPage(pageUrl: "http://localhost:8000/resourcetrackers.html")
    }
    
    func testThatRequestsAreBlocked() {
        runTestPage(pageUrl: "http://localhost:8000/requesttrackers.html")
    }
    
    func runTestPage(pageUrl: String) {
        
        newTab()
        
        enterSearch(pageUrl)
        
        waitForPageTitle()
        
        openContentBlocker()
        
        let popoverTrackerCount = app.tables.staticTexts["trackerCount"]
        let webTrackerCount = app.webViews.staticTexts.element(boundBy: PageElementIndex.uniqueTrackerCount)
        
        XCTAssertTrue(popoverTrackerCount.exists)
        XCTAssertTrue(webTrackerCount.exists)
        XCTAssertEqual(popoverTrackerCount.label, webTrackerCount.label)
    }
    
    private func showTabs() {
        app.toolbars.buttons["Tabs"].tap()
    }
    
    private func addTab() {
        app.toolbars.containing(.button, identifier:"Add").buttons["Add"].tap()
    }
    
    private func newTab() {
        showTabs()
        addTab()
    }
    
    private func openContentBlocker() {
        let navBar = app.navigationBars["DuckDuckGo.MainView"]
        navBar.otherElements["siteRating"].tap()
    }
    
    private func skipOnboarding() {
        guard app.staticTexts["Search Anonymously"].exists else { return  }
        app.pageIndicators["page 1 of 2"].tap()
        app.buttons["Done"].tap()
    }
    
    private func clearTabsAndData() {
        let app = XCUIApplication()
        let toolbarsQuery = app.toolbars
        toolbarsQuery.children(matching: .button).element(boundBy: 2).tap()
        app.sheets.buttons["Clear Tabs and Data"].tap()
    }
    
    private func enterSearch(_ text: String, submit: Bool = true) {
        print("enterSearch text:", text, "submit:", submit)
        
        let searchOrTypeUrlTextField = app.navigationBars["DuckDuckGo.MainView"].textFields["Search or type URL"]
        searchOrTypeUrlTextField.typeText(text)
        
        if submit {
            app.typeText("\n")
        }
    }
    
    private func waitForPageTitle() {
        sleep(2)
    }
    
    private func waitForToastToDisappear() {
        sleep(6)
    }
}

