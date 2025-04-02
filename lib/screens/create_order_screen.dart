import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math'; // Import for generating random order ID
import '../models/metal_type.dart';
import '../models/ornament_type.dart';
import '../constants/app_constants.dart';
import '../models/order.dart';
import '../screens/order_receipt_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _weightController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _discountController = TextEditingController();
  final _additionalChargesController = TextEditingController();
  final _cgstController = TextEditingController(text: '1.5');
  final _sgstController = TextEditingController(text: '1.5');
  final _makingChargesController = TextEditingController();

  // Selected values
  MetalType? _selectedMetal;
  OrnamentType? _selectedOrnament;
  DateTime _deliveryDate = DateTime.now().add(Duration(days: 7));

  // Sample data
  final List<MetalType> metals = [
    MetalType(name: '24K Gold', pricePerGram: 6000, purity: 24),
    MetalType(name: '22K Gold', pricePerGram: 5500, purity: 22),
    MetalType(name: '18K Gold', pricePerGram: 4500, purity: 18),
    MetalType(name: 'Silver', pricePerGram: 75, purity: 92.5),
  ];

  final List<OrnamentType> ornaments = [
    OrnamentType(
        name: 'Ring', makingChargesPercentage: 8, wastagePercentage: 3),
    OrnamentType(
        name: 'Necklace', makingChargesPercentage: 12, wastagePercentage: 5),
    OrnamentType(
        name: 'Bracelet', makingChargesPercentage: 10, wastagePercentage: 4),
    OrnamentType(
        name: 'Earrings', makingChargesPercentage: 8, wastagePercentage: 3),
    OrnamentType(
        name: 'Pendant', makingChargesPercentage: 9, wastagePercentage: 3),
    OrnamentType(
        name: 'Bangle', makingChargesPercentage: 11, wastagePercentage: 4),
  ];

  // Calculation variables
  double _metalCost = 0;
  double _makingCharges = 0;
  double _wastageCharges = 0;
  double _cgst = 0;
  double _sgst = 0;
  double _discount = 0;
  double _additionalCharges = 0;
  double _totalAmount = 0;

  int _currentStep = 0;
  bool _showPriceComparison = false;
  
  // Payment method
  String _selectedPaymentMethod = 'Cash';
  List<String> _paymentMethods = ['Cash', 'Credit Card', 'Debit Card', 'UPI', 'Bank Transfer'];

  // Add a variable to track if there are custom design requirements
  bool _hasCustomDesign = false;
  final _customDesignController = TextEditingController();
  
  // Order urgency
  bool _isUrgent = false;

  void _calculateCosts() {
    if (_selectedMetal == null ||
        _selectedOrnament == null ||
        _weightController.text.isEmpty) {
      return;
    }

    final weight = double.parse(_weightController.text);
    final cgstRate = double.tryParse(_cgstController.text) ?? 0;
    final sgstRate = double.tryParse(_sgstController.text) ?? 0;
    final makingChargesRate = double.tryParse(_makingChargesController.text) ??
        _selectedOrnament!.makingChargesPercentage;

    // Base metal cost
    _metalCost = weight * _selectedMetal!.pricePerGram;

    // Making charges
    _makingCharges = _metalCost * (makingChargesRate / 100);

    // Wastage charges
    _wastageCharges = _metalCost * (_selectedOrnament!.wastagePercentage / 100);

    // Subtotal before tax
    final subtotal = _metalCost + _makingCharges + _wastageCharges;

    // Tax calculations
    _cgst = subtotal * (cgstRate / 100);
    _sgst = subtotal * (sgstRate / 100);

    // Discount
    _discount =
        subtotal * (double.tryParse(_discountController.text) ?? 0) / 100;

    // Additional charges
    _additionalCharges =
        double.tryParse(_additionalChargesController.text) ?? 0;
        
    // Add urgent charges if needed
    if (_isUrgent) {
      _additionalCharges += subtotal * 0.05; // 5% rush fee
    }

    // Total amount
    _totalAmount = subtotal + _cgst + _sgst - _discount + _additionalCharges;

    setState(() {});
  }

  Map<String, double> _calculatePricesForAllKarats(double weight) {
    if (weight <= 0) return {};
    
    Map<String, double> prices = {};
    for (var metal in metals) {
      if (metal.name.contains('Gold')) {
        double basePrice = weight * metal.pricePerGram;
        prices[metal.name] = basePrice;
      }
    }
    return prices;
  }

  void _showConfirmationDialog(String orderId) {
    final order = Order(
      orderId: orderId,
      customerName: _customerNameController.text,
      phoneNumber: _phoneController.text,
      orderDate: DateTime.now(),
      metalType: _selectedMetal!.name,
      weight: double.parse(_weightController.text),
      ornamentType: _selectedOrnament!.name,
      hasCustomDesign: _hasCustomDesign,
      customDesign: _hasCustomDesign ? _customDesignController.text : null,
      metalCost: _metalCost,
      makingCharges: double.parse(_makingChargesController.text),
      makingChargesAmount: _makingCharges,
      customDesignCharges: _hasCustomDesign ? (_metalCost * 0.1) : null, // 10% of metal cost for custom design
      cgst: double.parse(_cgstController.text),
      sgst: double.parse(_sgstController.text),
      cgstAmount: _cgst,
      sgstAmount: _sgst,
      additionalCharges: _additionalCharges,
      discount: double.parse(_discountController.text.isEmpty ? "0" : _discountController.text),
      discountAmount: _discount,
      totalAmount: _totalAmount,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48.w),
              SizedBox(height: 16.h),
              Text('Order Created Successfully!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order ID: $orderId', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Text('Customer: ${_customerNameController.text}'),
              Text('Item: ${_selectedOrnament?.name} (${_selectedMetal?.name})'),
              Text('Weight: ${_weightController.text} grams'),
              Text('Delivery by: ${_deliveryDate.day}/${_deliveryDate.month}/${_deliveryDate.year}'),
              SizedBox(height: 8.h),
              Text('Total Amount: ₹${_totalAmount.toStringAsFixed(2)}', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height: 8.h),
              Text('Payment: $_selectedPaymentMethod'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderReceiptScreen(order: order),
                  ),
                );
              },
              child: Text('View Receipt'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: Text('Done'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  String _generateOrderId() {
    final random = Random();
    return 'JWL-${DateTime.now().year}${random.nextInt(10000).toString().padLeft(4, '0')}';
  }

  Future<void> _selectDeliveryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 60)),
    );
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600;
    final isPad = screenSize.width >= 768;
    
    // Adjust padding based on screen size
    final contentPadding = isTablet ? 24.0 : 16.0;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.add_circle_outline,
                color: AppColors.primaryColor,
                size: isPad ? 24.sp : 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Create New Order',
              style: AppTextStyles.heading2().copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary:  AppColors.primaryColor,
          ),
        ),
        child: Stepper(
          controlsBuilder: (context, details) {
            return Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(_currentStep < 2 ? 'Continue' : 'Create Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: Text('Back'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              if (_formKey.currentState?.validate() ?? false) {
                final orderId = _generateOrderId();
                _showConfirmationDialog(orderId);
              }
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          steps: [
            Step(
              title: Text('Customer Details'),
              content: _buildCustomerDetailsStep(),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: Text('Product Details'),
              content: _buildProductDetailsStep(),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: Text('Order Preview'),
              content: _buildOrderPreviewStep(),
              isActive: _currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCustomerDetailsStep() {
    final isPad = MediaQuery.of(context).size.width >= 768;
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isPad ? 18.sp : 16.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      labelText: 'Customer Name',
                      labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                      prefixIcon: Icon(Icons.person, size: 20.sp),
                    ),
                    style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter customer name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                      prefixIcon: Icon(Icons.phone, size: 20.sp),
                    ),
                    style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isPad ? 18.sp : 16.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ListTile(
                      title: Text(
                        'Delivery Date',
                        style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                      ),
                      subtitle: Text(
                        '${_deliveryDate.day}/${_deliveryDate.month}/${_deliveryDate.year}',
                        style: TextStyle(
                          fontSize: isPad ? 14.sp : 12.sp,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      trailing: Icon(
                        Icons.calendar_today,
                        size: isPad ? 24.sp : 20.sp,
                        color: AppColors.primaryColor,
                      ),
                      onTap: _selectDeliveryDate,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        'Urgent Order',
                        style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                      ),
                      subtitle: Text(
                        '5% additional charge for rush orders',
                        style: TextStyle(
                          fontSize: isPad ? 12.sp : 10.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      value: _isUrgent,
                      onChanged: (value) {
                        setState(() {
                          _isUrgent = value;
                          _calculateCosts();
                        });
                      },
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsStep() {
    final karat24Price = _weightController.text.isNotEmpty ? 
        double.parse(_weightController.text) * 6000 : 0;
        
    final Map<String, double> karatPrices = _weightController.text.isNotEmpty ? 
        _calculatePricesForAllKarats(double.parse(_weightController.text)) : {};
        
    final isPad = MediaQuery.of(context).size.width >= 768;
    final screenWidth = MediaQuery.of(context).size.width;
        
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metal Selection',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isPad ? 18.sp : 16.sp
                    )
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    child: DropdownButtonFormField<MetalType>(
                      value: _selectedMetal,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Select Metal',
                        labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        prefixIcon: Icon(Icons.monetization_on, size: 20.sp),
                      ),
                      items: metals.map((metal) {
                        return DropdownMenuItem(
                          value: metal,
                          child: Text(
                            '${metal.name} (₹${metal.pricePerGram}/g)',
                            style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMetal = value;
                          _calculateCosts();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: 'Weight (in grams)',
                      labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                      prefixIcon: Icon(Icons.scale, size: 20.sp),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.compare_arrows,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPriceComparison = !_showPriceComparison;
                          });
                        },
                        tooltip: 'Compare prices for different karats',
                      ),
                    ),
                    style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _calculateCosts();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ornament Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isPad ? 18.sp : 16.sp
                    )
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    child: DropdownButtonFormField<OrnamentType>(
                      value: _selectedOrnament,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Select Ornament Type',
                        labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        prefixIcon: Icon(Icons.diamond, size: 20.sp),
                      ),
                      items: ornaments.map((ornament) {
                        return DropdownMenuItem(
                          value: ornament,
                          child: Text(
                            '${ornament.name} (Making: ${ornament.makingChargesPercentage}%, Wastage: ${ornament.wastagePercentage}%)',
                            style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOrnament = value;
                          if (value != null) {
                            _makingChargesController.text = 
                                value.makingChargesPercentage.toString();
                          }
                          _calculateCosts();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        'Custom Design Required',
                        style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                      ),
                      value: _hasCustomDesign,
                      onChanged: (value) {
                        setState(() {
                          _hasCustomDesign = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                    ),
                  ),
                  if (_hasCustomDesign) ...[
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _customDesignController,
                      decoration: InputDecoration(
                        labelText: 'Design Description',
                        labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        prefixIcon: Icon(Icons.design_services, size: 20.sp),
                      ),
                      style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                      maxLines: 3,
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Charges & Tax',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isPad ? 18.sp : 16.sp
                    )
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _makingChargesController,
                          decoration: InputDecoration(
                            labelText: 'Making Charges (%)',
                            labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                          ),
                          style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _calculateCosts(),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: TextFormField(
                          controller: _discountController,
                          decoration: InputDecoration(
                            labelText: 'Discount (%)',
                            labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                          ),
                          style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _calculateCosts(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cgstController,
                          decoration: InputDecoration(
                            labelText: 'CGST (%)',
                            labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                          ),
                          style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _calculateCosts(),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: TextFormField(
                          controller: _sgstController,
                          decoration: InputDecoration(
                            labelText: 'SGST (%)',
                            labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                          ),
                          style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _calculateCosts(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _additionalChargesController,
                    decoration: InputDecoration(
                      labelText: 'Additional Charges',
                      labelStyle: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                    ),
                    style: TextStyle(fontSize: isPad ? 14.sp : 12.sp),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateCosts(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderPreviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Summary', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                SizedBox(height: 16.h),
                _buildCostRow('Metal Cost', _metalCost),
                _buildCostRow(
                    'Making Charges (${_makingChargesController.text}%)',
                    _makingCharges),
                _buildCostRow(
                    'Wastage Charges (${_selectedOrnament?.wastagePercentage ?? 0}%)',
                    _wastageCharges),
                _buildCostRow('CGST (${_cgstController.text}%)', _cgst),
                _buildCostRow('SGST (${_sgstController.text}%)', _sgst),
                _buildCostRow('Discount', -_discount),
                _buildCostRow('Additional Charges', _additionalCharges),
                if (_isUrgent)
                  _buildCostRow('Urgent Order Fee (5%)', _metalCost * 0.05),
                Divider(thickness: 1),
                _buildCostRow('Total Amount', _totalAmount, isTotal: true),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Method', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  decoration: InputDecoration(
                    labelText: 'Select Payment Method',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.payment),
                  ),
                  items: _paymentMethods.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Card(
          elevation: 4,
          color: Colors.amber.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade800),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    'By proceeding, you confirm that all details are correct and the customer has been informed of the total cost.',
                    style: TextStyle(fontSize: 14.sp, color: Colors.amber.shade800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green.shade700 : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _customerNameController.dispose();
    _phoneController.dispose();
    _discountController.dispose();
    _additionalChargesController.dispose();
    _cgstController.dispose();
    _sgstController.dispose();
    _makingChargesController.dispose();
    _customDesignController.dispose();
    super.dispose();
  }
}
