import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_constants.dart';
import '../models/click_data.dart';

class BitlinkItem extends StatelessWidget {
  final BitlinkData bitlink;

  const BitlinkItem({
    Key? key,
    required this.bitlink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.paddingM.h),
      padding: EdgeInsets.all(AppSizes.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusM.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIconContainer(),
          SizedBox(width: AppSizes.paddingM.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bitlink.title,
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  bitlink.url,
                  style: AppTextStyles.smallText,
                ),
                SizedBox(height: 4.h),
                Text(
                  bitlink.dateRange,
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.textSecondaryColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSizes.paddingM.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${bitlink.clicks}',
                style: AppTextStyles.heading3,
              ),
              SizedBox(height: 4.h),
              Text(
                'clicks',
                style: AppTextStyles.smallText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer() {
    Color iconColor;
    
    switch (bitlink.id) {
      case 'fr':
        iconColor = AppColors.primaryColor;
        break;
      case 'np':
        iconColor = AppColors.secondaryColor;
        break;
      case 'fs':
        iconColor = AppColors.tertiaryColor;
        break;
      default:
        iconColor = AppColors.primaryColor;
    }
    
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusS.r),
      ),
      alignment: Alignment.center,
      child: Text(
        bitlink.iconCode,
        style: TextStyle(
          color: iconColor,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    );
  }
} 