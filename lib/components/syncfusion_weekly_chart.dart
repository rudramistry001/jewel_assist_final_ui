import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../models/click_data.dart';

class SyncfusionWeeklyChart extends StatefulWidget {
  final List<DailyClickData> weeklyData;

  const SyncfusionWeeklyChart({
    Key? key,
    required this.weeklyData,
  }) : super(key: key);

  @override
  State<SyncfusionWeeklyChart> createState() => _SyncfusionWeeklyChartState();
}

class _SyncfusionWeeklyChartState extends State<SyncfusionWeeklyChart> {
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      animationDuration: 150,
      color: AppColors.primaryColor,
      textStyle: AppTextStyles.smallText().copyWith(
        color: Colors.white,
      ),
    );
    
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
    );
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingM.h,
        horizontal: AppSizes.paddingS.w,
      ),
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
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelStyle: AppTextStyles.smallText().copyWith(
            color: AppColors.textSecondaryColor,
          ),
          axisLine: const AxisLine(width: 0),
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
        tooltipBehavior: _tooltipBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        series: <ChartSeries<DailyClickData, String>>[
          // Area series for the background fill
          AreaSeries<DailyClickData, String>(
            dataSource: widget.weeklyData,
            xValueMapper: (DailyClickData data, _) => _getDayName(data.date.weekday),
            yValueMapper: (DailyClickData data, _) => data.clicks,
            name: 'Clicks',
            borderWidth: 0,
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withOpacity(0.3),
                AppColors.primaryColor.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            animationDuration: 1500,
            enableTooltip: false,
          ),
          // Line series for the main line
          SplineSeries<DailyClickData, String>(
            dataSource: widget.weeklyData,
            xValueMapper: (DailyClickData data, _) => _getDayName(data.date.weekday),
            yValueMapper: (DailyClickData data, _) => data.clicks,
            name: 'Clicks',
            color: AppColors.primaryColor,
            width: 3,
            markerSettings: MarkerSettings(
              isVisible: true,
              height: 8,
              width: 8,
              shape: DataMarkerType.circle,
              borderWidth: 2,
              borderColor: AppColors.primaryColor,
              color: Colors.white,
            ),
            animationDuration: 1500,
            enableTooltip: true,
          ),
        ],
        legend: Legend(isVisible: false),
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