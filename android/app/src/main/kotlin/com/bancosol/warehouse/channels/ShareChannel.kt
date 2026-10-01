package com.bancosol.warehouse.channels

import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ShareChannel : AppChannel() {
    override val name = "app/share"
    override val handlers = mapOf<String, ChannelHandler>("shareProduct" to ::shareProduct)

    private fun shareProduct(call: MethodCall, result: MethodChannel.Result) {
        val text = call.argument<String>("text")
        val host = activity
        if (text.isNullOrBlank() || host == null) return result.error("SHARE_FAILED", "nothing to share", null)
        val send = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, text)
            putExtra(Intent.EXTRA_SUBJECT, call.argument<String>("name"))
        }
        host.startActivity(Intent.createChooser(send, null))
        // El chooser de Android no reporta si el usuario completó el envío.
        result.success(false)
    }
}
