import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color secondaryColor = Color(0xFF6FCF97);
  static const Color tertiaryColor = Color(0xFFF2C94C);
  static const Color backgroundColor = Color(0xFFF5F8FA);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF828282);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color goldColor = Color(0xFFFFD700);
  static const Color errorColor = Color(0xFFEB5757);
  static const Color successColor = Color(0xFF27AE60);
}

class AppTextStyles {
  // Responsive text styles using ScreenUtil
  static TextStyle heading1({bool responsive = true}) {
    return TextStyle(
      fontSize: responsive ? 24.sp : 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryColor,
    );
  }
  
  static TextStyle heading2({bool responsive = true}) {
    return TextStyle(
      fontSize: responsive ? 20.sp : 20,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryColor,
    );
  }
  
  static TextStyle heading3({bool responsive = true}) {
    return TextStyle(
      fontSize: responsive ? 18.sp : 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryColor,
    );
  }
  
  static TextStyle bodyText({bool responsive = true}) {
    return TextStyle(
      fontSize: responsive ? 16.sp : 16,
      color: AppColors.textPrimaryColor,
    );
  }
  
  static TextStyle caption({bool responsive = true}) {
    return TextStyle(
      fontSize: responsive ? 14.sp : 14,
      color: AppColors.textSecondaryColor,
    );
  }
  
  static TextStyle smallText({bool responsive = true}) {
    return TextStyle(
      fontSize: responsive ? 12.sp : 12,
      color: AppColors.textSecondaryColor,
    );
  }
  
  // Legacy properties for backward compatibility
  static TextStyle get heading1Legacy => heading1(responsive: true);
  static TextStyle get heading2Legacy => heading2(responsive: true);
  static TextStyle get heading3Legacy => heading3(responsive: true);
  static TextStyle get bodyTextLegacy => bodyText(responsive: true);
  static TextStyle get captionLegacy => caption(responsive: true);
  static TextStyle get smallTextLegacy => smallText(responsive: true);
}

class AppSizes {
  // Fixed sizes 
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 16.0;
  
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  
  // Responsive sizes
  static double responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 32.0;
    if (width > 768) return 24.0;
    if (width > 600) return 20.0;
    return 16.0;
  }
  
  static double responsiveRadius(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 16.0;
    if (width > 600) return 12.0;
    return 8.0;
  }
} 