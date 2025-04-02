import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../constants/app_constants.dart';
import '../models/order.dart';
import 'package:intl/intl.dart';

class OrderReceiptScreen extends StatelessWidget {
  final Order order;

  const OrderReceiptScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPad = MediaQuery.of(context).size.width >= 768;
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
                Icons.receipt_long,
                color: AppColors.primaryColor,
                size: isPad ? 24.sp : 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Order Receipt',
              style: AppTextStyles.heading2().copyWith(
                color: AppColors.primaryColor,
                fontSize: isPad ? 20.sp : 18.sp,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              icon: Icon(
                Icons.share,
                size: isPad ? 24.sp : 20.sp,
                color: AppColors.primaryColor,
              ),
              onPressed: () => _generateAndSharePDF(context),
              tooltip: 'Share Receipt',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Receipt Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jewel Assist',
                                style: TextStyle(
                                  fontSize: isPad ? 24.sp : 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Order #${order.orderId}',
                                style: TextStyle(
                                  fontSize: isPad ? 16.sp : 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('MMM dd, yyyy').format(order.orderDate),
                                style: TextStyle(
                                  fontSize: isPad ? 16.sp : 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                DateFormat('hh:mm a').format(order.orderDate),
                                style: TextStyle(
                                  fontSize: isPad ? 14.sp : 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(height: 32.h),

                      // Customer Details
                      Text(
                        'Customer Details',
                        style: TextStyle(
                          fontSize: isPad ? 18.sp : 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildDetailRow('Name', order.customerName, isPad),
                      _buildDetailRow('Phone', order.phoneNumber, isPad),
                      SizedBox(height: 24.h),

                      // Product Details
                      Text(
                        'Product Details',
                        style: TextStyle(
                          fontSize: isPad ? 18.sp : 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildDetailRow('Metal Type', order.metalType, isPad),
                      _buildDetailRow('Weight', '${order.weight} grams', isPad),
                      _buildDetailRow('Ornament Type', order.ornamentType, isPad),
                      if (order.hasCustomDesign)
                        _buildDetailRow('Custom Design', order.customDesign ?? '', isPad),
                      SizedBox(height: 24.h),

                      // Charges Breakdown
                      Text(
                        'Charges Breakdown',
                        style: TextStyle(
                          fontSize: isPad ? 18.sp : 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildChargeRow('Metal Cost', order.metalCost, isPad),
                      _buildChargeRow('Making Charges (${order.makingCharges}%)',
                          order.makingChargesAmount, isPad),
                      if (order.hasCustomDesign)
                        _buildChargeRow('Custom Design Charges',
                            order.customDesignCharges ?? 0, isPad),
                      _buildChargeRow('CGST (${order.cgst}%)',
                          order.cgstAmount, isPad),
                      _buildChargeRow('SGST (${order.sgst}%)',
                          order.sgstAmount, isPad),
                      if (order.additionalCharges > 0)
                        _buildChargeRow('Additional Charges',
                            order.additionalCharges, isPad),
                      if (order.discount > 0)
                        _buildChargeRow('Discount (${order.discount}%)',
                            -order.discountAmount, isPad),
                      Divider(height: 32.h),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: isPad ? 20.sp : 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            '₹${formatter.format(order.totalAmount)}',
                            style: TextStyle(
                              fontSize: isPad ? 24.sp : 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Terms and Conditions
              SizedBox(height: 24.h),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: isPad ? 16.sp : 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '• All prices are inclusive of taxes\n'
                        '• Custom design orders cannot be cancelled\n'
                        '• Delivery date is subject to design complexity\n'
                        '• Payment terms as discussed\n'
                        '• Exchange policy applicable as per store policy',
                        style: TextStyle(
                          fontSize: isPad ? 14.sp : 12.sp,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isPad) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isPad ? 14.sp : 12.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isPad ? 14.sp : 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeRow(String label, double amount, bool isPad) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isPad ? 14.sp : 12.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            '₹${formatter.format(amount)}',
            style: TextStyle(
              fontSize: isPad ? 14.sp : 12.sp,
              fontWeight: FontWeight.w500,
              color: amount < 0 ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndSharePDF(BuildContext context) async {
    try {
      final pdf = pw.Document();
      final formatter = NumberFormat("#,##0.00", "en_US");

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Jewel Assist',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Order #${order.orderId}',
                          style: const pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          DateFormat('MMM dd, yyyy').format(order.orderDate),
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          DateFormat('hh:mm a').format(order.orderDate),
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Divider(),

                // Customer Details
                pw.SizedBox(height: 20),
                pw.Text(
                  'Customer Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildPDFDetailRow('Name', order.customerName),
                _buildPDFDetailRow('Phone', order.phoneNumber),

                // Product Details
                pw.SizedBox(height: 20),
                pw.Text(
                  'Product Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildPDFDetailRow('Metal Type', order.metalType),
                _buildPDFDetailRow('Weight', '${order.weight} grams'),
                _buildPDFDetailRow('Ornament Type', order.ornamentType),
                if (order.hasCustomDesign)
                  _buildPDFDetailRow('Custom Design', order.customDesign ?? ''),

                // Charges Breakdown
                pw.SizedBox(height: 20),
                pw.Text(
                  'Charges Breakdown',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildPDFChargeRow('Metal Cost',
                    '₹${formatter.format(order.metalCost)}'),
                _buildPDFChargeRow(
                    'Making Charges (${order.makingCharges}%)',
                    '₹${formatter.format(order.makingChargesAmount)}'),
                if (order.hasCustomDesign)
                  _buildPDFChargeRow(
                      'Custom Design Charges',
                      '₹${formatter.format(order.customDesignCharges ?? 0)}'),
                _buildPDFChargeRow('CGST (${order.cgst}%)',
                    '₹${formatter.format(order.cgstAmount)}'),
                _buildPDFChargeRow('SGST (${order.sgst}%)',
                    '₹${formatter.format(order.sgstAmount)}'),
                if (order.additionalCharges > 0)
                  _buildPDFChargeRow('Additional Charges',
                      '₹${formatter.format(order.additionalCharges)}'),
                if (order.discount > 0)
                  _buildPDFChargeRow('Discount (${order.discount}%)',
                      '-₹${formatter.format(order.discountAmount)}'),

                pw.Divider(),

                // Total
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Amount',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '₹${formatter.format(order.totalAmount)}',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Terms and Conditions
                pw.SizedBox(height: 40),
                pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  '• All prices are inclusive of taxes\n'
                  '• Custom design orders cannot be cancelled\n'
                  '• Delivery date is subject to design complexity\n'
                  '• Payment terms as discussed\n'
                  '• Exchange policy applicable as per store policy',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Get temporary directory
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/Order_${order.orderId}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Share the PDF file
      await Share.shareFiles(
        [file.path],
        text: 'Order Receipt #${order.orderId}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  pw.Widget _buildPDFDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPDFChargeRow(String label, String amount) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            amount,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 