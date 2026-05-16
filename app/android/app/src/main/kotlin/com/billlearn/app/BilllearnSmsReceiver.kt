package com.billlearn.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import java.security.MessageDigest

class BilllearnSmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            return
        }

        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        for (message in messages) {
            val body = message.messageBody ?: continue
            val timestamp = message.timestampMillis
            val sender = message.originatingAddress

            AndroidRawEventStream.emit(
                mapOf(
                    "id" to "sms-$timestamp-$sender",
                    "sourceType" to "sms",
                    "sourceApp" to null,
                    "sender" to sender,
                    "title" to null,
                    "body" to body,
                    "receivedAtMillis" to timestamp,
                    "sourceHash" to sha256("$sender|$body|$timestamp")
                )
            )
        }
    }

    private fun sha256(value: String): String {
        val digest = MessageDigest.getInstance("SHA-256").digest(value.toByteArray())
        return digest.joinToString("") { "%02x".format(it) }
    }
}
