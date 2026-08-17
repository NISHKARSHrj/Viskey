import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textprimary,
    letterSpacing: -1.0,
  );

  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textprimary,
    letterSpacing: -0.5,
  );

  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textprimary,
  );

  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textprimary,
    height: 1.4,
  );

  static const bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textsecondary,
    height: 1.4,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textsecondary,
  );

  static const button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
}
