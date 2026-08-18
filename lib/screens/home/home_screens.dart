import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        //header
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                const Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    "VISKEY",
                                                    style: AppTextStyles.headline,
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                    "See it, Unlock it. ",
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
                                        onTap: () {},
                                    ),
                            ],
                        ),
                        const SizedBox(height: 38),

                        //sec title
                        
                    ],  
                ),
                ),
            ),
    );
  }
}
