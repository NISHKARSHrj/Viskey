import 'dart:io';

import 'package:path_provider/path_provider.dart';

class VisualKeyService {
  Future<String> saveVisualKey({
    required String sourcePath,
    required String packageName,
  }) async {
    final directory =
        await getApplicationDocumentsDirectory();

    final visualKeysDirectory = Directory(
      '${directory.path}/visual_keys',
    );

    if (!await visualKeysDirectory.exists()) {
      await visualKeysDirectory.create(
        recursive: true,
      );
    }

    final safePackageName =
        packageName.replaceAll('.', '_');

    final destination = File(
      '${visualKeysDirectory.path}/$safePackageName.jpg',
    );

    final source = File(sourcePath);

    await source.copy(destination.path);

    return destination.path;
  }

  Future<void> deleteVisualKey(
    String path,
  ) async {
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }
}