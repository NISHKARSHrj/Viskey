import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'visual_key_camera_screen.dart';

class VisualKeySetupScreen extends StatelessWidget {
  final String appName;
  final String packageName;

  const VisualKeySetupScreen({
    super.key,
    required this.appName,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        title: const Text(
          'Visual Key',
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
            12,
            20,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Protect $appName',
                style: AppTextStyles.headline,
              ),

              const SizedBox(height: 10),

              const Text(
                'Create a Visual Key that you will use to unlock this app.',
                style: AppTextStyles.bodySecondary,
              ),

              const Spacer(),

              // Visual illustration
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: const Icon(
                    Icons.center_focus_strong_rounded,
                    size: 72,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Choose something you can easily recognize.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textprimary,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'For example, a bottle, watch, toy or any other object. '
                'VISKEY will use it as your visual key.',
                style: AppTextStyles.bodySecondary,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VisualKeyCameraScreen(
                          appName: appName,
                          packageName: packageName,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                  ),
                  label: const Text(
                    'Open Camera',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}