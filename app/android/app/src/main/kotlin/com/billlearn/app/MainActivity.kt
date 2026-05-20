package com.billlearn.app

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingSmsPermissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "billlearn.android/methods"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isNotificationAccessEnabled" -> result.success(isNotificationAccessEnabled())
                "openNotificationAccessSettings" -> {
                    startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                    result.success(null)
                }
                "isSmsPermissionGranted" -> result.success(isSmsPermissionGranted())
                "requestSmsPermission" -> requestSmsPermission(result)
                "drainPendingRawEvents" -> result.success(AndroidRawEventQueue.drain(this))
                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "billlearn.android/raw_events"
        ).setStreamHandler(AndroidRawEventStream)
    }

    private fun isNotificationAccessEnabled(): Boolean {
        val enabledListeners = Settings.Secure.getString(
            contentResolver,
            "enabled_notification_listeners"
        ) ?: return false

        return enabledListeners.contains(packageName)
    }

    private fun isSmsPermissionGranted(): Boolean {
        val receiveSmsGranted = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.RECEIVE_SMS
        ) == PackageManager.PERMISSION_GRANTED
        val readSmsGranted = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_SMS
        ) == PackageManager.PERMISSION_GRANTED

        return receiveSmsGranted && readSmsGranted
    }

    private fun requestSmsPermission(result: MethodChannel.Result) {
        if (isSmsPermissionGranted()) {
            result.success(true)
            return
        }

        if (pendingSmsPermissionResult != null) {
            result.error("sms_permission_pending", "SMS permission request is already pending.", null)
            return
        }

        pendingSmsPermissionResult = result
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.RECEIVE_SMS, Manifest.permission.READ_SMS),
            SMS_PERMISSION_REQUEST_CODE
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode != SMS_PERMISSION_REQUEST_CODE) {
            return
        }

        pendingSmsPermissionResult?.success(
            grantResults.isNotEmpty() &&
                grantResults.all { it == PackageManager.PERMISSION_GRANTED }
        )
        pendingSmsPermissionResult = null
    }

    companion object {
        private const val SMS_PERMISSION_REQUEST_CODE = 4201
    }
}
