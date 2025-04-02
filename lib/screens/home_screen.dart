import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../providers/analytics_provider.dart';
import '../components/syncfusion_weekly_chart.dart';
import '../models/jewelry_stats.dart';
import '../models/click_data.dart';
import './detailed_orders_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPad = MediaQuery.of(context).size.width >= 768;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final formatter = NumberFormat("#,##0.00", "en_US");
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Consumer<AnalyticsProvider>(
          builder: (context, provider, child) {
            final stats = provider.stats;
            
            return RefreshIndicator(
              onRefresh: () async {
                // Refresh data
              },
              child: CustomScrollView(
                slivers: [
                  // App Bar with Search
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    snap: false,
                    backgroundColor: AppColors.backgroundColor,
                    elevation: 0,
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.diamond_outlined, 
                            color: AppColors.primaryColor,
                            size: isPad ? 24.sp : 20.sp
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Jewel Assist',
                          style: AppTextStyles.heading2().copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.textPrimaryColor,
                          size: isPad ? 24.sp : 20.sp,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                  
                  // Main Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.paddingM.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Section
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.primaryColor.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(0.3),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 5.h),
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
                                      'Welcome Back!',
                                      style: AppTextStyles.heading2().copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Text(
                                        'Dashboard',
                                        style: AppTextStyles.bodyText().copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                // New Content: Quick Stats or Links
                                Wrap(
                                  spacing: 12.w,
                                  runSpacing: 12.w,
                                  children: [
                                    _buildQuickStat('1256', 'Total Customers', Icons.people),
                                    _buildQuickStat('473k', 'Total Revenue', Icons.attach_money),
                                    _buildQuickStat('4.8', 'Avg. Rating', Icons.star),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 24.h),
                          
                          // KPI Cards
                          Text(
                            'Business Performance',
                            style: AppTextStyles.heading2(),
                          ),
                          SizedBox(height: 12.h),
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.w,
                            children: [
                              _buildKpiCard(
                                'Monthly Growth',
                                '${stats.monthlyGrowth.toStringAsFixed(1)}%',
                                Icons.trending_up,
                                stats.monthlyGrowth >= 0 ? AppColors.successColor : AppColors.errorColor,
                                isPad,
                              ),
                              _buildKpiCard(
                                'Completed Orders',
                                '${stats.completedOrders}',
                                Icons.check_circle,
                                AppColors.successColor,
                                isPad,
                              ),
                              _buildKpiCard(
                                'In Progress',
                                '${stats.ordersInProgress}',
                                Icons.pending,
                                AppColors.primaryColor,
                                isPad,
                              ),
                              _buildKpiCard(
                                'Customer Rating',
                                '${stats.averageRating.toStringAsFixed(1)}',
                                Icons.star,
                                AppColors.primaryColor,
                                isPad,
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 24.h),
                          
                          // Gold Rate Chart
                          Text(
                            'Gold Rate Trends',
                            style: AppTextStyles.heading2(),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Last 7 days gold rate fluctuations',
                            style: AppTextStyles.caption(),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            height: 200.h,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 5.h),
                                ),
                              ],
                            ),
                            child: _buildGoldRateChart(stats.goldRates),
                          ),
                          
                          SizedBox(height: 24.h),
                          
                          // Category Revenue
                          Text(
                            'Revenue by Category',
                            style: AppTextStyles.heading2(),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 5.h),
                                ),
                              ],
                            ),
                            child: Column(
                              children: stats.categoryRevenue.entries.map((entry) {
                                final percentage = (entry.value / stats.totalRevenue * 100).toStringAsFixed(1);
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            entry.key,
                                            style: AppTextStyles.bodyText().copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '\$${formatter.format(entry.value)} (${percentage}%)',
                                            style: AppTextStyles.bodyText().copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      LinearProgressIndicator(
                                        value: entry.value / stats.totalRevenue,
                                        backgroundColor: Colors.grey[200],
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          _getCategoryColor(entry.key),
                                        ),
                                        minHeight: 8.h,
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          
                          SizedBox(height: 24.h),
                          
                          // Recent Orders
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Orders',
                                style: AppTextStyles.heading2(),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to detailed orders screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DetailedOrdersScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'View All',
                                  style: AppTextStyles.bodyText().copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 5.h),
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: stats.recentOrders.length > 5 ? 5 : stats.recentOrders.length,
                              separatorBuilder: (context, index) => Divider(height: 1.h),
                              itemBuilder: (context, index) {
                                final order = stats.recentOrders[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                  leading: Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(order.category).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        _getCategoryIcon(order.category),
                                        color: _getCategoryColor(order.category),
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    'Order #${order.orderId}',
                                    style: AppTextStyles.bodyText().copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${order.customerName} • ${DateFormat('MMM dd').format(order.date)}',
                                    style: AppTextStyles.caption().copyWith(fontSize: 12.sp),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${formatter.format(order.amount)}',
                                        style: AppTextStyles.bodyText().copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: order.status == 'Completed'
                                              ? AppColors.successColor.withOpacity(0.1)
                                              : AppColors.primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          order.status,
                                          style: AppTextStyles.smallText().copyWith(
                                            color: order.status == 'Completed'
                                                ? AppColors.successColor
                                                : AppColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildQuickStat(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              value,
              style: AppTextStyles.heading3().copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppTextStyles.caption().copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildKpiCard(String title, String value, IconData icon, Color color, bool isPad) {
    return Container(
      width: isPad ? 160.w : 140.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: isPad ? 24.sp : 20.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isPad ? 14.sp : 12.sp,
                    color: AppColors.textPrimaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: isPad ? 24.sp : 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGoldRateChart(List<GoldRate> goldRates) {
    // Convert gold rates to a format compatible with the chart
    final chartData = goldRates.map((rate) {
      return DailyClickData(
        date: rate.date,
        clicks: rate.rate.toInt(),
      );
    }).toList();
    
    return SyncfusionWeeklyChart(weeklyData: chartData);
  }
  
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'rings':
        return AppColors.primaryColor;
      case 'necklaces':
        return AppColors.secondaryColor;
      case 'earrings':
        return AppColors.tertiaryColor;
      case 'bracelets':
        return AppColors.primaryColor.withOpacity(0.8);
      case 'watches':
        return AppColors.secondaryColor.withOpacity(0.8);
      default:
        return AppColors.primaryColor;
    }
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'rings':
        return Icons.circle;
      case 'necklaces':
        return Icons.linear_scale;
      case 'earrings':
        return Icons.hearing;
      case 'bracelets':
        return Icons.watch;
      case 'watches':
        return Icons.watch_later;
      default:
        return Icons.diamond;
    }
  }

  Widget _buildDashboardCard(String title, String value, IconData icon, Color color, bool isPad) {
    return Container(
      width: isPad ? 200.w : 150.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: isPad ? 24.sp : 20.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isPad ? 14.sp : 12.sp,
                    color: AppColors.textPrimaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: isPad ? 24.sp : 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class GoldRateChartData {
  final DateTime date;
  final int rate;

  GoldRateChartData({
    required this.date,
    required this.rate,
  });
} 