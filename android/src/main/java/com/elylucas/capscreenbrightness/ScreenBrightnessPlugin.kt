package com.elylucas.capscreenbrightness

import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.PluginThread
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "ScreenBrightness")
public class ScreenBrightnessPlugin : Plugin() {
    // The window's attributes belong to the main thread
    @PluginMethod(thread = PluginThread.MAIN)
    public fun setBrightness(call: PluginCall) {
        val brightness = call.getFloat("brightness")
        val layoutParams = activity.window.attributes

        // A call without a brightness throws here, as it always has; on the MAIN thread the bridge rejects the call
        // with what it throws instead of letting it crash the app.
        layoutParams.screenBrightness = brightness!!
        activity.window.attributes = layoutParams
        call.resolve()
    }

    @PluginMethod
    public fun getBrightness(call: PluginCall) {
        val layoutParams = activity.window.attributes
        val ret = JSObject()
        // Written as a double, which is what Java widened the float to.
        ret.put("brightness", layoutParams.screenBrightness.toDouble())
        call.resolve(ret)
    }
}
