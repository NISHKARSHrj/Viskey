package com.klyro.viskey

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.util.Log

class ViskeyAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "VISKEY_SERVICE"
    }

    override fun onAccessibilityEvent(
        event: AccessibilityEvent?
    ) {
        if (event == null) return

        // We only care when the foreground window changes.
        if (event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            return
        }

        val packageName =
            event.packageName?.toString()
                ?: return

        Log.d(
            TAG,
            "Foreground app: $packageName"
        )

        // For now we are ONLY detecting apps.
        // Protection logic comes later.
    }

    override fun onInterrupt() {
        Log.d(
            TAG,
            "VISKEY Accessibility Service interrupted"
        )
    }

    override fun onServiceConnected() {
        super.onServiceConnected()

        Log.d(
            TAG,
            "VISKEY Accessibility Service connected"
        )
    }
}