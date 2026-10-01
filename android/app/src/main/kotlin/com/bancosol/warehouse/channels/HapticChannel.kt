package com.bancosol.warehouse.channels

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.view.HapticFeedbackConstants
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class HapticChannel : AppChannel() {
    override val name = "app/haptics"
    override val handlers = mapOf<String, ChannelHandler>("play" to ::play)

    private var richActuator: Boolean? = null

    private fun play(call: MethodCall, result: MethodChannel.Result) {
        val host = activity ?: return result.success(null)
        val supported = richActuator ?: hasRichActuator(host).also { richActuator = it }
        val constant = constantFor(call.arguments as? String)
        if (supported && constant != null) host.window.decorView.performHapticFeedback(constant)
        result.success(null)
    }

    // Si el fabricante no afinó CLICK/TICK para su motor, este solo zumba: mejor no vibrar.
    private fun hasRichActuator(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return false
        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.getSystemService(VibratorManager::class.java)?.defaultVibrator
        } else {
            context.getSystemService(Vibrator::class.java)
        } ?: return false
        return vibrator.hasVibrator() &&
            vibrator.areAllEffectsSupported(VibrationEffect.EFFECT_CLICK, VibrationEffect.EFFECT_TICK) ==
            Vibrator.VIBRATION_EFFECT_SUPPORT_YES
    }

    private fun constantFor(type: String?): Int? {
        val modern = Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE
        return when (type) {
            "selection" -> if (modern) HapticFeedbackConstants.SEGMENT_TICK else HapticFeedbackConstants.CLOCK_TICK
            "toggleOn" -> if (modern) HapticFeedbackConstants.TOGGLE_ON else HapticFeedbackConstants.CLOCK_TICK
            "toggleOff" -> if (modern) HapticFeedbackConstants.TOGGLE_OFF else HapticFeedbackConstants.CLOCK_TICK
            "refresh" -> if (modern) HapticFeedbackConstants.GESTURE_THRESHOLD_ACTIVATE else HapticFeedbackConstants.CLOCK_TICK
            "success" -> HapticFeedbackConstants.CONFIRM
            "error" -> HapticFeedbackConstants.REJECT
            else -> null
        }
    }
}
