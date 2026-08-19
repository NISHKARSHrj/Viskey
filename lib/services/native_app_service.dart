import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class InstalledApp {
  final String name;
  final String packageName;
  final Uint8List icon;

  const InstalledApp({
    required this.name,
    required this.packageName,
    required this.icon,
  });

  factory InstalledApp.fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return InstalledApp(
      name: map['name'] as String,
      packageName: map['packageName'] as String,
      icon: base64Decode(map['icon'] as String),
    );
  }
}

class NativeAppService {
  static const MethodChannel _channel =
      MethodChannel('viskey/native_apps');

  Future<List<InstalledApp>> getInstalledApps() async {
    final result = await _channel.invokeMethod<
        List<dynamic>>(
      'getInstalledApps',
    );

    if (result == null) {
      return [];
    }

    return result
        .map(
          (item) => InstalledApp.fromMap(
            Map<dynamic, dynamic>.from(item),
          ),
        )
        .toList();
  }
}