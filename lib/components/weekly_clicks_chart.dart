import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../constants/app_constants.dart';
import '../models/click_data.dart';
import 'package:intl/intl.dart';

class WeeklyClicksChart extends StatelessWidget {
  final List<DailyClickData> weeklyData;

  const WeeklyClicksChart({
    Key? key,
    required this.weeklyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (weeklyData.isEmpty) {
      return Container(
        height: 150.h,
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingM.h,
          horizontal: AppSizes.paddingS.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusM.r),
        ),
        child: Center(
          child: Text(
            'No data available',
            style: AppTextStyles.smallText().copyWith(
              color: AppColors.textSecondaryColor,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingM.h,
        horizontal: AppSizes.paddingS.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusM.r),
      ),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.all(0),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelStyle: AppTextStyles.smallText().copyWith(
            color: AppColors.textSecondaryColor,
          ),
          labelPlacement: LabelPlacement.onTicks,
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(
            width: 0.5,
            color: AppColors.dividerColor.withOpacity(0.5),
          ),
          labelStyle: AppTextStyles.smallText().copyWith(
            color: AppColors.textSecondaryColor,
          ),
          axisLine: const AxisLine(width: 0),
          numberFormat: NumberFormat.compact(),
        ),
        series: <CartesianSeries>[
          // Area series for background
          AreaSeries<DailyClickData, String>(
            dataSource: weeklyData,
            xValueMapper: (DailyClickData data, _) => _getDayName(data.date.weekday),
            yValueMapper: (DailyClickData data, _) => data.clicks,
            color: AppColors.primaryColor.withOpacity(0.2),
            borderWidth: 0,
            name: 'Clicks',
          ),
          // Spline series for the main line
          SplineSeries<DailyClickData, String>(
            dataSource: weeklyData,
            xValueMapper: (DailyClickData data, _) => _getDayName(data.date.weekday),
            yValueMapper: (DailyClickData data, _) => data.clicks,
            color: AppColors.primaryColor,
            width: 3,
            name: 'Clicks',
            markerSettings: const MarkerSettings(
              isVisible: false,
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          format: 'point.x : point.y clicks',
          color: Colors.blueGrey.withOpacity(0.8),
          textStyle: AppTextStyles.smallText().copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
} 