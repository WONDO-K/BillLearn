package com.billlearn.app

import android.content.Context
import io.flutter.plugin.common.EventChannel

object AndroidRawEventStream : EventChannel.StreamHandler {
    private var sink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    fun emit(context: Context, payload: Map<String, Any?>) {
        AndroidRawEventQueue.enqueue(context, payload)
        sink?.success(payload)
    }
}
