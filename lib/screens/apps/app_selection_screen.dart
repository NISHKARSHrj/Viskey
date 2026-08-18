import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
// in this i use mock app initially after that i take the real apps from the device
class AppSelectionScreen extends StatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  State<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<_MockApp> _apps = const [
    _MockApp(
      name: 'Instagram',
      packageName: 'com.instagram.android',
      icon: Icons.camera_alt_rounded,
    ),
    _MockApp(
      name: 'WhatsApp',
      packageName: 'com.whatsapp',
      icon: Icons.chat_rounded,
    ),
    _MockApp(
      name: 'Telegram',
      packageName: 'org.telegram.messenger',
      icon: Icons.send_rounded,
    ),
    _MockApp(
      name: 'YouTube',
      packageName: 'com.google.android.youtube',
      icon: Icons.play_arrow_rounded,
    ),
    _MockApp(
      name: 'Chrome',
      packageName: 'com.android.chrome',
      icon: Icons.language_rounded,
    ),
    _MockApp(
      name: 'Spotify',
      packageName: 'com.spotify.music',
      icon: Icons.music_note_rounded,
    ),
  ];

  final Set<String> _selectedApps = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_MockApp> get _filteredApps {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _apps;
    }

    return _apps
        .where(
          (app) => app.name.toLowerCase().contains(query),
        )
        .toList();
  }

  void _toggleApp(String packageName) {
    setState(() {
      if (_selectedApps.contains(packageName)) {
        _selectedApps.remove(packageName);
      } else {
        _selectedApps.add(packageName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apps = _filteredApps;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Protect an App',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose an app you want VISKEY to protect.',
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: 20),

              // Search
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search apps',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 21,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: ListView.separated(
                  itemCount: apps.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    final selected =
                        _selectedApps.contains(app.packageName);

                    return _AppSelectionTile(
                      app: app,
                      selected: selected,
                      onTap: () => _toggleApp(app.packageName),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _selectedApps.isEmpty
                      ? null
                      : () {
                          // Next:
                          // Open Visual Key setup.
                        },
                  child: Text(
                    _selectedApps.isEmpty
                        ? 'Select an App'
                        : 'Continue',
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

class _AppSelectionTile extends StatelessWidget {
  final _MockApp app;
  final bool selected;
  final VoidCallback onTap;

  const _AppSelectionTile({
    required this.app,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.55)
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfacesecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  app.icon,
                  color: AppColors.textprimary,
                  size: 23,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      app.packageName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppColors.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textsecondary,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.black,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockApp {
  final String name;
  final String packageName;
  final IconData icon;

  const _MockApp({
    required this.name,
    required this.packageName,
    required this.icon,
  });
}