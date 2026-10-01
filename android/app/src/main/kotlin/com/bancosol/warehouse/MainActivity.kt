package com.bancosol.warehouse

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app/share").setMethodCallHandler { call, result ->
            if (call.method != "shareProduct") return@setMethodCallHandler result.notImplemented()
            val text = call.argument<String>("text")
            if (text.isNullOrBlank()) return@setMethodCallHandler result.error("SHARE_FAILED", "empty text", null)
            val send = Intent(Intent.ACTION_SEND).apply {
                type = "text/plain"
                putExtra(Intent.EXTRA_TEXT, text)
                putExtra(Intent.EXTRA_SUBJECT, call.argument<String>("name"))
            }
            startActivity(Intent.createChooser(send, null))
            result.success(false)
        }
    }
}
