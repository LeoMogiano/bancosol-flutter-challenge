package com.bancosol.warehouse.channels

import io.flutter.embedding.engine.FlutterEngine

object PlatformChannels {
    fun register(engine: FlutterEngine) {
        engine.plugins.add(setOf(ShareChannel()))
    }
}
