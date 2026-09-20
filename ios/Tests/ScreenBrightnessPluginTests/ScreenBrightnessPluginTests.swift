import XCTest
@testable import ScreenBrightnessPlugin

class ScreenBrightnessTests: XCTestCase {
    func testPluginMethods() {
        let plugin = ScreenBrightnessPlugin()

        XCTAssertEqual(plugin.jsName, "ScreenBrightness")
        XCTAssertEqual(plugin.pluginMethods.map { $0.name }, ["setBrightness", "getBrightness"])
    }
}
