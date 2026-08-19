import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/protected_app.dart';
import '../../services/storage_service.dart';
import '../apps/app_selection_screen.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreens> {
  final StorageService _storageService = StorageService();

  List<ProtectedApp> _protectedApps = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProtectedApps();
  }

  // ─────────────────────────────────────────────
  // LOAD PROTECTED APPS
  // ─────────────────────────────────────────────

  Future<void> _loadProtectedApps() async {
    setState(() {
      _loading = true;
    });

    try {
      final apps = await _storageService.getProtectedApps();

      if (!mounted) return;

      setState(() {
        _protectedApps = apps;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not load protected apps: $e',
          ),
        ),
      );
    }
  }

  // ─────────────────────────────────────────────
  // OPEN APP SELECTION
  // ─────────────────────────────────────────────

  Future<void> _protectAnApp() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AppSelectionScreen(),
      ),
    );

    // When we return from App Selection /
    // Visual Key flow, refresh the HomeScreen.
    await _loadProtectedApps();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────────
              // HEADER
              // ─────────────────────────────────

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VISKEY',
                          style: AppTextStyles.headline,
                        ),

                        SizedBox(height: 3),

                        Text(
                          'See it. Unlock it.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _HeaderIconButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      // Notifications later.
                    },
                  ),
                ],
              ),

              const SizedBox(height: 38),

              // ─────────────────────────────────
              // PROTECTED APPS TITLE
              // ─────────────────────────────────

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Protected apps.',
                      style: AppTextStyles.title,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfacesecondary,
                      borderRadius:
                          BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: Text(
                      '${_protectedApps.length}',
                      style: const TextStyle(
                        color: AppColors.textsecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ─────────────────────────────────
              // APP CONTENT
              // ─────────────────────────────────

              Expanded(
                child: _buildProtectedAppsContent(),
              ),

              // ─────────────────────────────────
              // PROTECT APP BUTTON
              // ─────────────────────────────────

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _protectAnApp,
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 21,
                  ),
                  label: const Text(
                    'Protect an App',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ─────────────────────────────────
              // SETTINGS
              // ─────────────────────────────────

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Settings later.
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: 18,
                  ),
                  label: const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PROTECTED APPS CONTENT
  // ─────────────────────────────────────────────

  Widget _buildProtectedAppsContent() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_protectedApps.isEmpty) {
      return const _EmptyProtectedApps();
    }

    return ListView.separated(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      itemCount: _protectedApps.length,
      separatorBuilder: (_, _) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        final app = _protectedApps[index];

        return _ProtectedAppCard(
          app: app,
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// PROTECTED APP CARD
// ═══════════════════════════════════════════════════════════

class _ProtectedAppCard extends StatelessWidget {
  final ProtectedApp app;

  const _ProtectedAppCard({
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // App icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.surfacesecondary,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.apps_rounded,
              color: AppColors.textprimary,
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          // App information
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  app.appName,
                  style: const TextStyle(
                    color: AppColors.textprimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'Visual Key',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          // Protected badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withValues(
                  alpha: 0.30,
                ),
              ),
            ),
            child: const Text(
              'Protected',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════

class _EmptyProtectedApps extends StatelessWidget {
  const _EmptyProtectedApps();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lock icon
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.surfacesecondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'No protected apps',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textprimary,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Protect an app with your visual key.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.visibility_off_outlined,
                  size: 14,
                  color: AppColors.textsecondary,
                ),

                const SizedBox(width: 6),

                const Text(
                  'Your visual key stays on your device',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// HEADER ICON
// ═══════════════════════════════════════════════════════════

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.textprimary,
          ),
        ),
      ),
    );
  }
}