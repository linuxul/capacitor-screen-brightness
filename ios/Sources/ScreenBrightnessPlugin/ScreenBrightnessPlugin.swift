import Foundation
import UIKit
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ScreenBrightnessPlugin)
public class ScreenBrightnessPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ScreenBrightnessPlugin"
    public let jsName = "ScreenBrightness"
    public let pluginMethods: [CAPPluginMethod] = [
        .promise("setBrightness", ScreenBrightnessPlugin.setBrightness),
        .async("getBrightness", ScreenBrightnessPlugin.getBrightness)
    ]

    /// The setter stays synchronous: the bridge queue runs it in the order of the calls and it hands its UIKit work to
    /// the main queue in that order, so the last call wins. An async method would not keep that order.
    func setBrightness(_ call: CAPPluginCall) {
        let brightness = call.getFloat("brightness")
        DispatchQueue.main.async {
            // Without a brightness, the current one: UIScreen is read on the main thread, like it is written.
            UIScreen.main.brightness = CGFloat(brightness ?? Float(UIScreen.main.brightness))
            call.resolve()
        }
    }

    /// UIScreen belongs to the main thread, so the read runs on the main actor instead of the bridge queue. CGFloat is a
    /// Double, which JavaScript receives as the same number.
    @MainActor
    func getBrightness(_ call: CAPPluginCall) async -> JSObject {
        return ["brightness": Double(UIScreen.main.brightness)]
    }
}
