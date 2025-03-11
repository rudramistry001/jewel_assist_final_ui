import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/jewelry_stats.dart';

class EditOrderDialog extends StatefulWidget {
  final OrderStats order;
  final Function(OrderStats) onSave;

  const EditOrderDialog({
    Key? key,
    required this.order,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  late TextEditingController _customerNameController;
  late TextEditingController _amountController;
  late String _selectedStatus;
  late String _selectedCategory;

  final List<String> _statuses = ['Completed', 'In Progress', 'Pending'];
  final List<String> _categories = [
    'Rings',
    'Necklaces',
    'Earrings',
    'Bracelets',
    'Watches'
  ];

  @override
  void initState() {
    super.initState();
    _customerNameController =
        TextEditingController(text: widget.order.customerName);
    _amountController =
        TextEditingController(text: widget.order.amount.toString());
    _selectedStatus = widget.order.status;
    _selectedCategory = widget.order.category;
  }

  @override
  Widget build(BuildContext context) {
    final isPad = MediaQuery.of(context).size.width >= 768;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        width: isPad ? 500.w : 350.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Order',
              style: TextStyle(
                fontSize: isPad ? 24.sp : 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Order ID: ${widget.order.orderId}',
              style: TextStyle(
                fontSize: isPad ? 16.sp : 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _customerNameController,
              decoration: InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              items: _statuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: isPad ? 16.sp : 14.sp),
                  ),
                ),
                SizedBox(width: 16.w),
                ElevatedButton(
                  onPressed: () {
                    final updatedOrder = OrderStats(
                      orderId: widget.order.orderId,
                      customerName: _customerNameController.text,
                      amount: double.tryParse(_amountController.text) ??
                          widget.order.amount,
                      date: widget.order.date,
                      status: _selectedStatus,
                      category: _selectedCategory,
                    );
                    widget.onSave(updatedOrder);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: isPad ? 16.sp : 14.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
