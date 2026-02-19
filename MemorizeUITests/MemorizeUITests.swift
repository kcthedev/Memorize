import XCTest

final class MemorizeUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    @MainActor
    func testDeckTap() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let deck = app.descendants(matching: .any)["deck"]
        deck.tap()
        
        let notHittable = NSPredicate(format: "isHittable == false")
        expectation(for: notHittable, evaluatedWith: deck, handler: nil)
        
        waitForExpectations(timeout: 5.0) { error in
            if error != nil {
                XCTFail("The deck is still visible after tapping 😕")
            }
        }
    }
}
