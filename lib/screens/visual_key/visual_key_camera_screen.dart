import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'visual_key_confirm_screen.dart';

class VisualKeyCameraScreen extends StatefulWidget {
  final String appName;
  final String packageName;

  const VisualKeyCameraScreen({
    super.key,
    required this.appName,
    required this.packageName,
  });

  @override
  State<VisualKeyCameraScreen> createState() =>
      _VisualKeyCameraScreenState();
}

class _VisualKeyCameraScreenState
    extends State<VisualKeyCameraScreen> {
  CameraController? _controller;

  List<CameraDescription> _cameras = [];

  bool _isInitializing = true;
  bool _isCapturing = false;

  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        throw Exception('No camera found');
      }

      final camera = _cameras.firstWhere(
        (camera) =>
            camera.lensDirection ==
            CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isInitializing = false;
      });
    }
  }

  Future<void> _capturePhoto() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isCapturing) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      final image = await controller.takePicture();

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VisualKeyConfirmScreen(
            appName: widget.appName,
            packageName: widget.packageName,
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not capture photo: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ─────────────────────────────────────
            // CAMERA
            // ─────────────────────────────────────

            Positioned.fill(
              child: _buildCamera(),
            ),

            // ─────────────────────────────────────
            // TOP BAR
            // ─────────────────────────────────────

            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  _CircleButton(
                    icon: Icons.close_rounded,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'VISKEY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─────────────────────────────────────
            // BOTTOM CONTROLS
            // ─────────────────────────────────────

            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                children: [
                  const Text(
                    'Place your visual key inside the frame',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 18),

                  GestureDetector(
                    onTap: _capturePhoto,
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 150,
                      ),
                      width: _isCapturing ? 68 : 76,
                      height: _isCapturing ? 68 : 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary
                                .withValues(alpha: 0.35),
                            blurRadius: 22,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: _isCapturing
                          ? const Padding(
                              padding: EdgeInsets.all(22),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.black,
                              size: 28,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCamera() {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white54,
                size: 48,
              ),

              const SizedBox(height: 16),

              const Text(
                'Camera unavailable',
                style: AppTextStyles.title,
              ),

              const SizedBox(height: 8),

              Text(
                _error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
      );
    }

    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    // Keep the native camera aspect ratio.
    // Do NOT use BoxFit.cover here because that
    // caused the live preview to appear zoomed.

    return Padding(
      padding: const EdgeInsets.only(
        top: 60,
        bottom: 155,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox.expand(
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
    );
  }
}