import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_constants.dart';
import '../models/click_data.dart';

class WeeklyClicksChart extends StatelessWidget {
  final List<DailyClickData> weeklyData;

  const WeeklyClicksChart({
    Key? key,
    required this.weeklyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10000,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: _getMaxY(),
          lineBarsData: [
            LineChartBarData(
              spots: _getSpots(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.3),
                  AppColors.primaryColor,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.2),
                    AppColors.primaryColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (value.toInt() >= weeklyData.length) {
      return const SizedBox.shrink();
    }
    
    final style = AppTextStyles.smallText().copyWith(
      color: AppColors.textSecondaryColor,
    );
    
    final date = weeklyData[value.toInt()].date;
    final dayName = _getDayName(date.weekday);
    
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(dayName, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = AppTextStyles.smallText().copyWith(
      color: AppColors.textSecondaryColor,
    );
    
    String text;
    if (value >= 1000) {
      text = '${(value / 1000).toStringAsFixed(0)}k';
    } else {
      text = value.toStringAsFixed(0);
    }
    
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  List<FlSpot> _getSpots() {
    return List.generate(weeklyData.length, (index) {
      return FlSpot(index.toDouble(), weeklyData[index].clicks.toDouble());
    });
  }

  double _getMaxY() {
    double maxY = 0;
    for (var data in weeklyData) {
      if (data.clicks > maxY) {
        maxY = data.clicks.toDouble();
      }
    }
    return maxY * 1.2; // Add 20% padding to the top
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