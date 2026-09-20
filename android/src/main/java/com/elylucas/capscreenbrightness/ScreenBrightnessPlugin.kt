package com.elylucas.capscreenbrightness

import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "ScreenBrightness")
public class ScreenBrightnessPlugin : Plugin() {
    @PluginMethod
    public fun setBrightness(call: PluginCall) {
        val brightness = call.getFloat("brightness")
        val activity = activity
        val layoutParams = activity.window.attributes

        activity.runOnUiThread {
            // A call without a brightness has always thrown here, on the UI thread, rather than being rejected.
            layoutParams.screenBrightness = brightness!!
            activity.window.attributes = layoutParams
            call.resolve()
        }
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
