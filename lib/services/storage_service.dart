import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/protected_app.dart';

class StorageService {
  static const String _protectedAppsKey = 'protected_apps';

  Future<List<ProtectedApp>> getProtectedApps() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_protectedAppsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(data);

    return decoded
        .map(
          (item) => ProtectedApp.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> saveProtectedApp(
    ProtectedApp app,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final apps = await getProtectedApps();

    apps.removeWhere(
      (existing) =>
          existing.packageName == app.packageName,
    );

    apps.add(app);

    final encoded = jsonEncode(
      apps.map((app) => app.toJson()).toList(),
    );

    await prefs.setString(
      _protectedAppsKey,
      encoded,
    );
  }

  Future<void> removeProtectedApp(
    String packageName,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final apps = await getProtectedApps();

    apps.removeWhere(
      (app) => app.packageName == packageName,
    );

    await prefs.setString(
      _protectedAppsKey,
      jsonEncode(
        apps.map((app) => app.toJson()).toList(),
      ),
    );
  }
}