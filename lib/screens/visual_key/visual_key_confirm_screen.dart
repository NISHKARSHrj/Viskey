import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../models/protected_app.dart';
import '../../services/storage_service.dart';
import '../../services/visual_key_service.dart';
import 'visual_key_created_screen.dart';

class VisualKeyConfirmScreen extends StatefulWidget {
  final String appName;
  final String packageName;
  final String imagePath;

  const VisualKeyConfirmScreen({
    super.key,
    required this.appName,
    required this.packageName,
    required this.imagePath,
  });

  @override
  State<VisualKeyConfirmScreen> createState() =>
      _VisualKeyConfirmScreenState();
}

class _VisualKeyConfirmScreenState
    extends State<VisualKeyConfirmScreen> {
  bool _saving = false;

  final VisualKeyService _visualKeyService =
      VisualKeyService();

  final StorageService _storageService =
      StorageService();

  Future<void> _usePhoto() async {
    if (_saving) return;

    setState(() {
      _saving = true;
    });

    try {
      // 1. Save image to VISKEY private storage.
      final savedPath =
          await _visualKeyService.saveVisualKey(
        sourcePath: widget.imagePath,
        packageName: widget.packageName,
      );

      // 2. Create protected app record.
      final protectedApp = ProtectedApp(
        appName: widget.appName,
        packageName: widget.packageName,
        visualKeyPath: savedPath,
      );

      // 3. Save protected app metadata.
      await _storageService.saveProtectedApp(
        protectedApp,
      );

      if (!mounted) return;

      // 4. Show success screen.
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VisualKeyCreatedScreen(
            appName: widget.appName,
            visualKeyPath: savedPath,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not save Visual Key: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _saving
              ? null
              : () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        title: const Text(
          'Confirm Visual Key',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Use this as your key for ${widget.appName}?',
                style: AppTextStyles.headline,
              ),

              const SizedBox(height: 8),

              const Text(
                'Make sure the object is clearly visible. '
                'You will need to show this visual key '
                'when unlocking the app.',
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(22),
                  child: Image.file(
                    File(widget.imagePath),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saving
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text(
                        'Retake',
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton(
                      onPressed:
                          _saving ? null : _usePhoto,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'Use Photo',
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}