import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class VisualKeyCreatedScreen extends StatelessWidget {
  final String appName;
  final String visualKeyPath;

  const VisualKeyCreatedScreen({
    super.key,
    required this.appName,
    required this.visualKeyPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20,
          ),
          child: Column(
            children: [
              const Spacer(),

              // Success icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 52,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Visual Key Created',
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                '$appName is now protected.',
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Saved visual key preview
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(visualKeyPath),
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),

              const Spacer(),

              // Done
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text(
                    'Done',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Retake
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Retake',
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