package com.billlearn.app

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

object AndroidRawEventQueue {
    private const val PREFS_NAME = "billlearn_raw_event_queue"
    private const val KEY_PENDING_EVENTS = "pending_events"

    // Flutter가 아직 EventChannel을 열지 못한 상태의 결제 알림을 다음 앱 시작 때 회수하기 위한 최소 queue입니다.
    fun enqueue(context: Context, payload: Map<String, Any?>) {
        val preferences = context.applicationContext.getSharedPreferences(
            PREFS_NAME,
            Context.MODE_PRIVATE
        )
        val events = JSONArray(preferences.getString(KEY_PENDING_EVENTS, "[]"))
        events.put(JSONObject(payload.withoutNullValues()))
        preferences.edit().putString(KEY_PENDING_EVENTS, events.toString()).apply()
    }

    fun drain(context: Context): List<Map<String, Any?>> {
        val preferences = context.applicationContext.getSharedPreferences(
            PREFS_NAME,
            Context.MODE_PRIVATE
        )
        val events = JSONArray(preferences.getString(KEY_PENDING_EVENTS, "[]"))
        preferences.edit().remove(KEY_PENDING_EVENTS).apply()

        return buildList {
            for (index in 0 until events.length()) {
                add(events.getJSONObject(index).toMap())
            }
        }
    }

    private fun Map<String, Any?>.withoutNullValues(): Map<String, Any> {
        return entries
            .filter { it.value != null }
            .associate { it.key to it.value as Any }
    }

    private fun JSONObject.toMap(): Map<String, Any?> {
        return keys().asSequence().associateWith { key ->
            val value = get(key)
            if (value == JSONObject.NULL) null else value
        }
    }
}
