import XCTest
import Capacitor
import UIKit
@testable import ScreenBrightnessPlugin

class ScreenBrightnessTests: XCTestCase {
    func testPluginMethods() {
        let plugin = ScreenBrightnessPlugin()

        XCTAssertEqual(plugin.jsName, "ScreenBrightness")
        XCTAssertEqual(plugin.pluginMethods.map { $0.name }, ["setBrightness", "getBrightness"])
        XCTAssertTrue(plugin.pluginMethods.allSatisfy { $0.returnType == .promise })
    }

    @MainActor
    func testGetBrightnessReturnsTheScreenBrightness() async {
        let call = CAPPluginCall(callbackId: "test", methodName: "getBrightness", options: [:], success: { _, _ in
            XCTFail("getBrightness answers by returning")
        }, error: { _ in
            XCTFail("getBrightness must not reject")
        })
        let result = await ScreenBrightnessPlugin().getBrightness(call)
        XCTAssertEqual(result["brightness"] as? Double, Double(UIScreen.main.brightness))
    }

    func testSetBrightnessWithoutABrightnessResolvesOnTheMainQueue() {
        let resolved = expectation(description: "setBrightness resolves")
        ScreenBrightnessPlugin().setBrightness(CAPPluginCall(callbackId: "test", methodName: "setBrightness", options: [:], success: { _, _ in
            XCTAssertTrue(Thread.isMainThread)
            resolved.fulfill()
        }, error: { _ in
            XCTFail("setBrightness must not reject")
        }))
        wait(for: [resolved], timeout: 20)
    }
}
