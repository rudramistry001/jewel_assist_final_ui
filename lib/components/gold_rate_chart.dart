import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
    if (rates.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    if (rates.length < 2) {
      return Center(
        child: Text(
          'Insufficient data for chart',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final isPad = MediaQuery.of(context).size.width >= 768;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final formatter = NumberFormat("#,##0.00", "en_US");

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
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: isPad ? 12.sp : 10.sp,
              ),
              axisLabelFormatter: (AxisLabelRenderDetails args) {
                final index = int.tryParse(args.text ?? '0') ?? 0;
                if (index >= 0 && index < rates.length) {
                  final date = rates[index].date;
                  switch (timeRange) {
                    case 'Weekly':
                      return ChartAxisLabel(DateFormat('EEE').format(date), null);
                    case 'Monthly':
                      return ChartAxisLabel(DateFormat('dd/MM').format(date), null);
                    case 'Quarterly':
                      return ChartAxisLabel(DateFormat('MMM').format(date), null);
                    default:
                      return ChartAxisLabel(DateFormat('MMM').format(date), null);
                  }
                }
                return ChartAxisLabel('', null);
              },
            ),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.currency(symbol: '\$', decimalDigits: 2),
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: isPad ? 12.sp : 10.sp,
              ),
              axisLine: const AxisLine(width: 0),
              majorGridLines: MajorGridLines(
                width: 0.5,
                color: Colors.grey[300],
              ),
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.x : \$point.y',
              color: Colors.blueGrey.withOpacity(0.8),
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: isPad ? 14.sp : 12.sp,
              ),
            ),
            series: <CartesianSeries<GoldRate, String>>[
              SplineAreaSeries<GoldRate, String>(
                dataSource: rates,
                xValueMapper: (GoldRate rate, _) => 
                    DateFormat('MMM dd').format(rate.date),
                yValueMapper: (GoldRate rate, _) => rate.rate,
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderColor: Theme.of(context).primaryColor,
                borderWidth: 2,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  height: 6.r,
                  width: 6.r,
                  borderWidth: 2,
                  borderColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
