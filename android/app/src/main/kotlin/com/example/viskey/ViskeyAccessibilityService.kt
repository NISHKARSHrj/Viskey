package com.klyro.viskey

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class ViskeyAccessibilityService :
    AccessibilityService() {

    companion object {
        private const val TAG =
            "VISKEY_SERVICE"
    }

    private var lastPackageName: String? = null

    override fun onAccessibilityEvent(
        event: AccessibilityEvent?
    ) {
        if (event == null) return

        if (
            event.eventType !=
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
        ) {
            return
        }

        val packageName =
            event.packageName?.toString()
                ?: return

        // Avoid processing the same app repeatedly.
        if (packageName == lastPackageName) {
            return
        }

        lastPackageName = packageName

        Log.d(
            TAG,
            "Foreground app: $packageName"
        )

        // Ignore VISKEY itself.
        if (
            packageName ==
            applicationContext.packageName
        ) {
            return
        }

        if (
            ViskeyProtectedApps.isProtected(
                this,
                packageName
            )
        ) {
            Log.d(
                TAG,
                "Protected app opened: $packageName"
            )

            launchLockActivity(packageName)
        }
    }

    private fun launchLockActivity(
        packageName: String
    ) {
        val intent = Intent(
            this,
            ViskeyLockActivity::class.java
        )

        intent.putExtra(
            "protected_package",
            packageName
        )

        intent.addFlags(
            Intent.FLAG_ACTIVITY_NEW_TASK or
            Intent.FLAG_ACTIVITY_CLEAR_TOP
        )

        startActivity(intent)
    }

    override fun onServiceConnected() {
        super.onServiceConnected()

        Log.d(
            TAG,
            "VISKEY Accessibility Service connected"
        )
    }

    override fun onInterrupt() {
        Log.d(
            TAG,
            "VISKEY Accessibility Service interrupted"
        )
    }
}