package com.klyro.viskey

import android.content.Context

object ViskeyProtectedApps {

    private const val PREFS_NAME =
        "viskey_native"

    private const val KEY_PROTECTED_PACKAGES =
        "protected_packages"

    fun saveProtectedPackage(
        context: Context,
        packageName: String
    ) {
        val prefs =
            context.getSharedPreferences(
                PREFS_NAME,
                Context.MODE_PRIVATE
            )

        val current =
            prefs.getStringSet(
                KEY_PROTECTED_PACKAGES,
                emptySet()
            )?.toMutableSet()
                ?: mutableSetOf()

        current.add(packageName)

        prefs.edit()
            .putStringSet(
                KEY_PROTECTED_PACKAGES,
                current
            )
            .apply()
    }

    fun removeProtectedPackage(
        context: Context,
        packageName: String
    ) {
        val prefs =
            context.getSharedPreferences(
                PREFS_NAME,
                Context.MODE_PRIVATE
            )

        val current =
            prefs.getStringSet(
                KEY_PROTECTED_PACKAGES,
                emptySet()
            )?.toMutableSet()
                ?: mutableSetOf()

        current.remove(packageName)

        prefs.edit()
            .putStringSet(
                KEY_PROTECTED_PACKAGES,
                current
            )
            .apply()
    }

    fun isProtected(
        context: Context,
        packageName: String
    ): Boolean {

        val prefs =
            context.getSharedPreferences(
                PREFS_NAME,
                Context.MODE_PRIVATE
            )

        val protectedPackages =
            prefs.getStringSet(
                KEY_PROTECTED_PACKAGES,
                emptySet()
            ) ?: emptySet()

        return packageName in protectedPackages
    }
}