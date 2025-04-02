import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../components/stat_card.dart';
import '../components/gold_rate_chart.dart';
import '../providers/analytics_provider.dart';
import 'package:intl/intl.dart';
import '../screens/detailed_orders_screen.dart';
import '../constants/app_constants.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isPad = MediaQuery.of(context).size.width >= 768;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.analytics,
                color: AppColors.primaryColor,
                size: isPad ? 24.sp : 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Analytics Dashboard',
              style: AppTextStyles.heading2().copyWith(
                color: AppColors.primaryColor,
                fontSize: isPad ? 20.sp : 18.sp,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              icon: Icon(
                Icons.calendar_today,
                size: isPad ? 24.sp : 20.sp,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                _showDateRangePicker(context);
              },
              tooltip: 'Select Date Range',
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                size: isPad ? 24.sp : 20.sp,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                _refreshData(context);
              },
              tooltip: 'Refresh Data',
            ),
          ),
        ],
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          final stats = provider.stats;
          final formatter = NumberFormat("#,##0.00", "en_US");

          return RefreshIndicator(
            onRefresh: () async {
              await provider.refreshData();
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isPad ? 24.w : 16.w,
                    vertical: isPad ? 24.h : 16.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Header Section with enhanced design
                      Container(
                        padding: EdgeInsets.all(isPad ? 24.w : 20.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Revenue',
                                      style: TextStyle(
                                        fontSize: isPad ? 16.sp : 14.sp,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      '\$${formatter.format(stats.totalRevenue)}',
                                      style: TextStyle(
                                        fontSize: isPad ? 32.sp : 28.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.trending_up,
                                        color: Colors.white,
                                        size: isPad ? 22.sp : 18.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '+${stats.monthlyGrowth}%',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isPad ? 16.sp : 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMiniStat(
                                  context,
                                  'Orders',
                                  stats.completedOrders.toString(),
                                  Icons.shopping_bag,
                                  isPad,
                                ),
                                _buildMiniStat(
                                  context,
                                  'Customers',
                                  stats.totalCustomers.toString(),
                                  Icons.people,
                                  isPad,
                                ),
                                _buildMiniStat(
                                  context,
                                  'Rating',
                                  '${stats.averageRating}★',
                                  Icons.star,
                                  isPad,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Stats Grid with enhanced responsiveness
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: _calculateCrossAxisCount(
                            screenWidth, isPad, isTablet, isLandscape),
                        mainAxisSpacing: isPad ? 24.w : 16.w,
                        crossAxisSpacing: isPad ? 24.w : 16.w,
                        childAspectRatio: _calculateChildAspectRatio(
                            screenWidth, isPad, isLandscape),
                        children: [
                          StatCard(
                            title: 'Completed Orders',
                            value: stats.completedOrders.toString(),
                            icon: Icons.check_circle_outline,
                            color: Colors.green,
                          ),
                          StatCard(
                            title: 'Orders in Progress',
                            value: stats.ordersInProgress.toString(),
                            icon: Icons.pending_actions,
                            color: Colors.orange,
                          ),
                          StatCard(
                            title: 'Total Revenue',
                            value: '\$${formatter.format(stats.totalRevenue)}',
                            icon: Icons.attach_money,
                            color: Colors.blue,
                          ),
                          StatCard(
                            title: 'Average Order Value',
                            value:
                                '\$${formatter.format(stats.totalRevenue / stats.completedOrders)}',
                            icon: Icons.analytics,
                            color: Colors.purple,
                          ),
                          StatCard(
                            title: 'Total Customers',
                            value: stats.totalCustomers.toString(),
                            icon: Icons.people,
                            color: Colors.teal,
                          ),
                          StatCard(
                            title: 'Customer Rating',
                            value: '${stats.averageRating} ★',
                            icon: Icons.star,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                      SizedBox(height: isPad ? 32.h : 24.h),

                      // Category Revenue Section
                      Container(
                        padding: EdgeInsets.all(isPad ? 24.w : 16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Revenue by Category',
                                  style: TextStyle(
                                    fontSize: isPad ? 20.sp : 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    'Total: \$${formatter.format(stats.totalRevenue)}',
                                    style: TextStyle(
                                      fontSize: isPad ? 14.sp : 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            ...stats.categoryRevenue.entries.map((entry) {
                              final percentage =
                                  (entry.value / stats.totalRevenue * 100)
                                      .toStringAsFixed(1);
                              final categoryColors = {
                                'Rings': Colors.blue,
                                'Necklaces': Colors.purple,
                                'Earrings': Colors.pink,
                                'Bracelets': Colors.teal,
                                'Watches': Colors.amber,
                              };
                              final color = categoryColors[entry.key] ??
                                  Theme.of(context).colorScheme.primary;

                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 12.w,
                                              height: 12.w,
                                              decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              entry.key,
                                              style: TextStyle(
                                                fontSize: isPad ? 16.sp : 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '\$${formatter.format(entry.value)} ($percentage%)',
                                          style: TextStyle(
                                            fontSize: isPad ? 16.sp : 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 10.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor:
                                              entry.value / stats.totalRevenue,
                                          child: Container(
                                            height: 10.h,
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: color.withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: isPad ? 32.h : 24.h),

                      // Gold Rate Analysis Section
                      Container(
                        padding: EdgeInsets.all(isPad ? 24.w : 16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gold Rate Analysis',
                                  style: TextStyle(
                                    fontSize: isPad ? 20.sp : 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(30.r),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: provider.timeRange,
                                    underline: const SizedBox(),
                                    isDense: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: isPad ? 22.sp : 20.sp,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    items: [
                                      'Weekly',
                                      'Monthly',
                                      'Quarterly',
                                      'Yearly'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontSize: isPad ? 14.sp : 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        provider.updateTimeRange(newValue);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isPad ? 24.h : 16.h),
                            GoldRateChart(
                              rates: provider.goldRates,
                              timeRange: provider.timeRange,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isPad ? 32.h : 24.h),

                      // Recent Orders Section
                      Container(
                        padding: EdgeInsets.all(isPad ? 24.w : 16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Orders',
                                  style: TextStyle(
                                    fontSize: isPad ? 20.sp : 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DetailedOrdersScreen(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.visibility,
                                    size: isPad ? 20.sp : 18.sp,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  label: Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: isPad ? 14.sp : 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 20.w,
                                horizontalMargin: 0,
                                headingRowHeight: 50.h,
                                dataRowMinHeight: 60.h,
                                dataRowMaxHeight: 60.h,
                                headingRowColor: MaterialStateProperty.all(
                                  Colors.grey[100],
                                ),
                                headingTextStyle: TextStyle(
                                  fontSize: isPad ? 16.sp : 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Order ID',
                                      style: TextStyle(
                                          fontSize: isPad ? 14.sp : 12.sp),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Customer',
                                      style: TextStyle(
                                          fontSize: isPad ? 14.sp : 12.sp),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Amount',
                                      style: TextStyle(
                                          fontSize: isPad ? 14.sp : 12.sp),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Status',
                                      style: TextStyle(
                                          fontSize: isPad ? 14.sp : 12.sp),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Category',
                                      style: TextStyle(
                                          fontSize: isPad ? 14.sp : 12.sp),
                                    ),
                                  ),
                                ],
                                rows: stats.recentOrders.map((order) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                        order.orderId,
                                        style: TextStyle(
                                          fontSize: isPad ? 14.sp : 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                      DataCell(Text(
                                        order.customerName,
                                        style: TextStyle(
                                          fontSize: isPad ? 14.sp : 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                      DataCell(Text(
                                        '\$${formatter.format(order.amount)}',
                                        style: TextStyle(
                                          fontSize: isPad ? 14.sp : 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[700],
                                        ),
                                      )),
                                      DataCell(Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: order.status == 'Completed'
                                              ? Colors.green.withOpacity(0.1)
                                              : order.status == 'In Progress'
                                                  ? Colors.orange
                                                      .withOpacity(0.1)
                                                  : Colors.grey
                                                      .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color: order.status == 'Completed'
                                                ? Colors.green.withOpacity(0.3)
                                                : order.status == 'In Progress'
                                                    ? Colors.orange
                                                        .withOpacity(0.3)
                                                    : Colors.grey
                                                        .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          order.status,
                                          style: TextStyle(
                                            color: order.status == 'Completed'
                                                ? Colors.green
                                                : order.status == 'In Progress'
                                                    ? Colors.orange
                                                    : Colors.grey,
                                            fontSize: isPad ? 14.sp : 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )),
                                      DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: Text(
                                            order.category,
                                            style: TextStyle(
                                              fontSize: isPad ? 14.sp : 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _exportReport(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: Icon(Icons.download, size: isPad ? 24.sp : 20.sp),
        label: Text(
          'Export Report',
          style: TextStyle(
              fontSize: isPad ? 16.sp : 14.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _refreshData(BuildContext context) async {
    // Simulate refresh with a delay
    await Future.delayed(const Duration(seconds: 1));

    // Show a snackbar to indicate refresh
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data refreshed successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _exportReport(BuildContext context) {
    // Show a snackbar to indicate export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report exported successfully!'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange != null) {
      // Show a snackbar to indicate date range selection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Date range selected: ${DateFormat('MMM dd, yyyy').format(newDateRange.start)} - ${DateFormat('MMM dd, yyyy').format(newDateRange.end)}',
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildMiniStat(BuildContext context, String title, String value,
      IconData icon, bool isPad) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: isPad ? 20.sp : 16.sp,
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: isPad ? 12.sp : 10.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isPad ? 16.sp : 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount(
      double screenWidth, bool isPad, bool isTablet, bool isLandscape) {
    if (screenWidth > 1200) return 6;
    if (screenWidth > 1000) return 5;
    if (isPad) return isLandscape ? 4 : 3;
    if (isTablet) return isLandscape ? 3 : 2;
    return 2;
  }

  double _calculateChildAspectRatio(
      double screenWidth, bool isPad, bool isLandscape) {
    if (screenWidth > 1200) return 1.5;
    if (screenWidth > 1000) return 1.4;
    if (isPad) return isLandscape ? 1.8 : 1.6;
    return isLandscape ? 1.6 : 1.4;
  }
}
