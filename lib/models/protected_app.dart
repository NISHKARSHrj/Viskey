class ProtectedApp {
  final String appName;
  final String packageName;
  final String visualKeyPath;

  const ProtectedApp({
    required this.appName,
    required this.packageName,
    required this.visualKeyPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'visualKeyPath': visualKeyPath,
    };
  }

  factory ProtectedApp.fromJson(Map<String, dynamic> json) {
    return ProtectedApp(
      appName: json['appName'] as String,
      packageName: json['packageName'] as String,
      visualKeyPath: json['visualKeyPath'] as String,
    );
  }
}