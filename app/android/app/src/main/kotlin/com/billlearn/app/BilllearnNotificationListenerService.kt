package com.billlearn.app

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import java.security.MessageDigest

class BilllearnNotificationListenerService : NotificationListenerService() {
    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val extras = sbn.notification.extras
        val title = extras.getCharSequence("android.title")?.toString()
        val text = extras.getCharSequence("android.text")?.toString() ?: return
        val body = listOfNotNull(title, text).joinToString(" ")

        AndroidRawEventStream.emit(
            this,
            mapOf(
                "id" to "push-${sbn.postTime}-${sbn.packageName}",
                "sourceType" to "push",
                "sourceApp" to sbn.packageName,
                "sender" to null,
                "title" to title,
                "body" to body,
                "receivedAtMillis" to sbn.postTime,
                "sourceHash" to sha256("${sbn.packageName}|$body|${sbn.postTime}")
            )
        )
    }

    private fun sha256(value: String): String {
        val digest = MessageDigest.getInstance("SHA-256").digest(value.toByteArray())
        return digest.joinToString("") { "%02x".format(it) }
    }
}
