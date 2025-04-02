import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jewel_assist/models/jewelry_stats.dart';
import 'package:provider/provider.dart';
import '../providers/analytics_provider.dart';
import 'package:intl/intl.dart';
import '../widgets/edit_order_dialog.dart';
import '../services/pdf_service.dart';
import '../constants/app_constants.dart';

class DetailedOrdersScreen extends StatelessWidget {
  const DetailedOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPad = MediaQuery.of(context).size.width >= 768;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final formatter = NumberFormat("#,##0.00", "en_US");

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                Icons.list_alt,
                color: AppColors.primaryColor,
                size: isPad ? 24.sp : 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Order Details',
              style: AppTextStyles.heading2().copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              size: isPad ? 24.sp : 20.sp,
              color: AppColors.textPrimaryColor,
            ),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: isPad ? 24.sp : 20.sp,
              color: AppColors.textPrimaryColor,
            ),
            onPressed: () => _showSearchDialog(context),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          final stats = provider.stats;

          return Column(
            children: [
              // Order Statistics Cards
              Container(
                padding: EdgeInsets.all(16.w),
                child: Wrap(
                  spacing: 12.w,
                  runSpacing: 12.w,
                  children: [
                    _buildStatCard(
                      'Total Orders',
                      '${stats.completedOrders + stats.ordersInProgress}',
                      Icons.shopping_bag,
                      Colors.blue,
                      isPad,
                    ),
                    _buildStatCard(
                      'Completed',
                      '${stats.completedOrders}',
                      Icons.check_circle,
                      Colors.green,
                      isPad,
                    ),
                    _buildStatCard(
                      'In Progress',
                      '${stats.ordersInProgress}',
                      Icons.pending,
                      Colors.orange,
                      isPad,
                    ),
                  ],
                ),
              ),

              // Orders List
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20.w,
                          horizontalMargin: 16.w,
                          headingRowHeight: 50.h,
                          dataRowHeight: 70.h,
                          headingTextStyle: TextStyle(
                            fontSize: isPad ? 16.sp : 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          columns: [
                            DataColumn(label: Text('Order ID')),
                            DataColumn(label: Text('Customer')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Actions')),
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
                                  DateFormat('MMM dd, yyyy').format(order.date),
                                  style: TextStyle(
                                    fontSize: isPad ? 14.sp : 12.sp,
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
                                DataCell(_buildStatusChip(order.status, isPad)),
                                DataCell(Text(
                                  order.category,
                                  style: TextStyle(
                                    fontSize: isPad ? 14.sp : 12.sp,
                                  ),
                                )),
                                DataCell(Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.visibility,
                                          color: Colors.blue, size: 20.sp),
                                      onPressed: () =>
                                          _showOrderDetails(context, order),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Colors.green, size: 20.sp),
                                      onPressed: () =>
                                          _showEditDialog(context, order),
                                    ),
                                  ],
                                )),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _exportOrdersReport(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.download, size: isPad ? 24.sp : 20.sp),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, bool isPad) {
    return Expanded(
      child: Container(
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
                Icon(icon, color: color, size: isPad ? 20.sp : 16.sp),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isPad ? 14.sp : 12.sp,
                    color: Colors.grey[700],
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
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isPad) {
    final color = status == 'Completed'
        ? Colors.green
        : status == 'In Progress'
            ? Colors.orange
            : Colors.grey;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: isPad ? 14.sp : 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    // Implement filter dialog
  }

  void _showSearchDialog(BuildContext context) {
    // Implement search dialog
  }

  void _showOrderDetails(BuildContext context, dynamic order) {
    // Implement order details dialog
  }

  void _showEditDialog(BuildContext context, OrderStats order) {
    showDialog(
      context: context,
      builder: (context) => EditOrderDialog(
        order: order,
        onSave: (updatedOrder) {
          // Update the order in your provider
          Provider.of<AnalyticsProvider>(context, listen: false)
              .updateOrder(updatedOrder);
        },
      ),
    );
  }

  void _exportOrdersReport(BuildContext context) async {
    final orders = Provider.of<AnalyticsProvider>(context, listen: false)
        .stats
        .recentOrders;

    await PdfService.generateAndShareOrdersReport(orders, context);
  }
}
