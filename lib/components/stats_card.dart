import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_constants.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? backgroundColor;
  final Color? textColor;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(AppSizes.paddingM.r),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusM.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: textColor ?? AppColors.textSecondaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextStyles.heading1.copyWith(
              color: textColor ?? AppColors.textPrimaryColor,
              fontSize: 28.sp,
            ),
          ),
        ],
      ),
    );
  }
} 