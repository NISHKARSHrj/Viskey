import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/native_app_service.dart';
import '../visual_key/visual_key_setup_screen.dart';

class AppSelectionScreen extends StatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  State<AppSelectionScreen> createState() =>
      _AppSelectionScreenState();
}

class _AppSelectionScreenState
    extends State<AppSelectionScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final NativeAppService _nativeAppService =
      NativeAppService();

  List<InstalledApp> _apps = [];

  final Set<String> _selectedApps = {};

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //real apps

  Future<void> _loadApps() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final apps =
          await _nativeAppService.getInstalledApps();

      if (!mounted) return;

      setState(() {
        _apps = apps;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  // SEARCH

  List<InstalledApp> get _filteredApps {
    final query =
        _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _apps;
    }

    return _apps.where((app) {
      return app.name.toLowerCase().contains(query);
    }).toList();
  }

  // SELECT / DESELECT
  void _toggleApp(String packageName) {
    setState(() {
      if (_selectedApps.contains(packageName)) {
        _selectedApps.remove(packageName);
      } else {
        // VISKEY currently supports one app at a time
        // during Visual Key creation.
        _selectedApps.clear();
        _selectedApps.add(packageName);
      }
    });
  }


  // CONTINUE


  void _continue() {
    if (_selectedApps.length != 1) {
      return;
    }

    final packageName = _selectedApps.first;

    final app = _apps.firstWhere(
      (app) => app.packageName == packageName,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VisualKeySetupScreen(
          appName: app.name,
          packageName: app.packageName,
        ),
      ),
    );
  }

  
  // BUILD
  

  @override
  Widget build(BuildContext context) {
    final apps = _filteredApps;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
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
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose an app you want VISKEY to protect.',
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: 20),

              
              // SEARCH
              

              TextField(
                controller: _searchController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: 'Search apps',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 21,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              
              // APP LIST
              

              Expanded(
                child: _buildAppContent(apps),
              ),

              const SizedBox(height: 14),

              
              // CONTINUE
              

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed:
                      _selectedApps.length == 1
                          ? _continue
                          : null,
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

  // APP CONTENT
  

  Widget _buildAppContent(
    List<InstalledApp> apps,
  ) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_error != null) {
      return _ErrorState(
        message: _error!,
        onRetry: _loadApps,
      );
    }

    if (apps.isEmpty) {
      return const Center(
        child: Text(
          'No apps found',
          style: AppTextStyles.bodySecondary,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      itemCount: apps.length,
      separatorBuilder: (_, _) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        final app = apps[index];

        final selected =
            _selectedApps.contains(
          app.packageName,
        );

        return _AppSelectionTile(
          app: app,
          selected: selected,
          onTap: () {
            _toggleApp(app.packageName);
          },
        );
      },
    );
  }
}


// APP TILE


class _AppSelectionTile extends StatelessWidget {
  final InstalledApp app;
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
            borderRadius:
                BorderRadius.circular(16),

            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(
                      alpha: 0.55,
                    )
                  : AppColors.border,
            ),
          ),

          child: Row(
            children: [

              // REAL APP ICON

              Container(
                width: 44,
                height: 44,

                padding:
                    const EdgeInsets.all(7),

                decoration: BoxDecoration(
                  color:
                      AppColors.surfacesecondary,
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Image.memory(
                  app.icon,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return const Icon(
                      Icons.apps_rounded,
                      color:
                          AppColors.textprimary,
                      size: 23,
                    );
                  },
                ),
              ),

              const SizedBox(width: 13),

              // APP INFORMATION

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      app.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            AppColors.textprimary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      app.packageName,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          AppTextStyles.caption,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // CHECK

              AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 180,
                ),

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

// ERROR STATE
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 42,
            ),

            const SizedBox(height: 14),

            const Text(
              'Could not load apps',
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              message,
              maxLines: 4,
              overflow:
                  TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.bodySecondary,
            ),

            const SizedBox(height: 18),

            OutlinedButton(
              onPressed: onRetry,
              child: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}