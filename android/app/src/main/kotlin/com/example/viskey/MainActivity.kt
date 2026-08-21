package com.klyro.viskey

import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.util.Base64
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {

    private companion object {
        const val CHANNEL = "viskey/native_apps"
    }

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {


                // GET INSTALLED APPS

                "getInstalledApps" -> {
                    try {
                        result.success(
                            getInstalledApps()
                        )
                    } catch (e: Exception) {
                        result.error(
                            "APP_ERROR",
                            e.message,
                            null
                        )
                    }
                }

                // SAVE PROTECTED PACKAGE

                "saveProtectedPackage" -> {

                    val packageName =
                        call.argument<String>(
                            "packageName"
                        )

                    if (packageName.isNullOrBlank()) {
                        result.error(
                            "INVALID_PACKAGE",
                            "Package name is missing",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        ViskeyProtectedApps
                            .saveProtectedPackage(
                                applicationContext,
                                packageName
                            )

                        result.success(true)

                    } catch (e: Exception) {
                        result.error(
                            "SAVE_PROTECTED_ERROR",
                            e.message,
                            null
                        )
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

// GET INSTALLED APPS

    private fun getInstalledApps():
        List<Map<String, Any>> {

        val packageManager = packageManager

        val intent = Intent(
            Intent.ACTION_MAIN,
            null
        ).apply {
            addCategory(
                Intent.CATEGORY_LAUNCHER
            )
        }

        val activities =
            packageManager.queryIntentActivities(
                intent,
                PackageManager.MATCH_ALL
            )

        return activities
            .mapNotNull { resolveInfo ->

                val activityInfo =
                    resolveInfo.activityInfo
                        ?: return@mapNotNull null

                val packageName =
                    activityInfo.packageName

                // Don't show VISKEY itself.
                if (
                    packageName ==
                    applicationContext.packageName
                ) {
                    return@mapNotNull null
                }

                val appName =
                    activityInfo
                        .applicationInfo
                        .loadLabel(
                            packageManager
                        )
                        .toString()

                val icon =
                    activityInfo
                        .applicationInfo
                        .loadIcon(
                            packageManager
                        )

                mapOf(
                    "name" to appName,
                    "packageName" to packageName,
                    "icon" to drawableToBase64(icon)
                )
            }
            .distinctBy {
                it["packageName"]
            }
            .sortedBy {
                it["name"]
                    .toString()
                    .lowercase()
            }
    }

    // CONVERT ICON → BASE64

    private fun drawableToBase64(
        drawable: Drawable
    ): String {

        val width =
            if (drawable.intrinsicWidth > 0) {
                drawable.intrinsicWidth
            } else {
                96
            }

        val height =
            if (drawable.intrinsicHeight > 0) {
                drawable.intrinsicHeight
            } else {
                96
            }

        val bitmap = Bitmap.createBitmap(
            width,
            height,
            Bitmap.Config.ARGB_8888
        )

        val canvas = Canvas(bitmap)

        drawable.setBounds(
            0,
            0,
            canvas.width,
            canvas.height
        )

        drawable.draw(canvas)

        val outputStream =
            ByteArrayOutputStream()

        bitmap.compress(
            Bitmap.CompressFormat.PNG,
            100,
            outputStream
        )

        return Base64.encodeToString(
            outputStream.toByteArray(),
            Base64.NO_WRAP
        )
    }
}