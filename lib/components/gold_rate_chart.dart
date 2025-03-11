import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/jewelry_stats.dart';
import 'package:intl/intl.dart';

class GoldRateChart extends StatelessWidget {
  final List<GoldRate> rates;
  final String timeRange;

  const GoldRateChart({
    Key? key,
    required this.rates,
    required this.timeRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPad = MediaQuery.of(context).size.width >= 768;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final formatter = NumberFormat("#,##0.00", "en_US");

    // Calculate min and max rates for the Y-axis
    final minRate = rates.map((e) => e.rate).reduce((a, b) => a < b ? a : b);
    final maxRate = rates.map((e) => e.rate).reduce((a, b) => a > b ? a : b);
    final rateRange = maxRate - minRate;

    // Calculate latest rate change
    final latestRate = rates.last;
    final previousRate = rates[rates.length - 2];
    final rateChange = latestRate.rate - previousRate.rate;
    final rateChangePercentage = (rateChange / previousRate.rate) * 100;

    return Column(
      children: [
        // Current Rate and Change
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Rate',
                  style: TextStyle(
                    fontSize: isPad ? 16.sp : 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '\$${formatter.format(latestRate.rate)}/oz',
                  style: TextStyle(
                    fontSize: isPad ? 24.sp : 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: rateChange >= 0
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    rateChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: rateChange >= 0 ? Colors.green : Colors.red,
                    size: isPad ? 20.sp : 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${rateChange >= 0 ? '+' : ''}${formatter.format(rateChange)} (${rateChangePercentage.toStringAsFixed(2)}%)',
                    style: TextStyle(
                      color: rateChange >= 0 ? Colors.green : Colors.red,
                      fontSize: isPad ? 14.sp : 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Chart
        SizedBox(
          height: isLandscape ? 200.h : 250.h,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: rateRange / 5,
                verticalInterval: rates.length / 6,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50.w,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '\$${formatter.format(value)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isPad ? 12.sp : 10.sp,
                        ),
                      );
                    },
                    interval: rateRange / 5,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < rates.length) {
                        final date = rates[value.toInt()].date;
                        String label;
                        switch (timeRange) {
                          case 'Weekly':
                            label = DateFormat('EEE').format(date);
                            break;
                          case 'Monthly':
                            label = DateFormat('dd/MM').format(date);
                            break;
                          case 'Quarterly':
                            label = DateFormat('MMM').format(date);
                            break;
                          default:
                            label = DateFormat('MMM').format(date);
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isPad ? 12.sp : 10.sp,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 30.h,
                    interval: rates.length / 6,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: rates.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.rate);
                  }).toList(),
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 2.w,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3.r,
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 1.w,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final date = rates[touchedSpot.x.toInt()].date;
                      return LineTooltipItem(
                        '${DateFormat('MMM dd, yyyy').format(date)}\n\$${formatter.format(touchedSpot.y)}',
                        TextStyle(
                          color: Colors.white,
                          fontSize: isPad ? 14.sp : 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
