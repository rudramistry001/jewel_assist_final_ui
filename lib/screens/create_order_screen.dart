import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math'; // Import for generating random order ID
import '../models/metal_type.dart';
import '../models/ornament_type.dart';

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

    // Total amount
    _totalAmount = subtotal + _cgst + _sgst - _discount + _additionalCharges;

    setState(() {});
  }

  void _showConfirmationDialog(String orderId) {
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
          content: Text('Your order ID is: $orderId'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Close the order screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _generateOrderId() {
    final random = Random();
    return 'ORD-${random.nextInt(1000000).toString().padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Order'),
      ),
      body: Stepper(
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
            content: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      labelText: 'Customer Name',
                      border: OutlineInputBorder(),
                    ),
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
                      border: OutlineInputBorder(),
                    ),
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
          Step(
            title: Text('Product Details'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<MetalType>(
                  value: _selectedMetal,
                  decoration: InputDecoration(
                    labelText: 'Select Metal',
                    border: OutlineInputBorder(),
                  ),
                  items: metals.map((metal) {
                    return DropdownMenuItem(
                      value: metal,
                      child: Text('${metal.name} (₹${metal.pricePerGram}/g)'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMetal = value;
                      _calculateCosts();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a metal';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<OrnamentType>(
                  value: _selectedOrnament,
                  decoration: InputDecoration(
                    labelText: 'Select Ornament Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ornaments.map((ornament) {
                    return DropdownMenuItem(
                      value: ornament,
                      child: Text(ornament.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOrnament = value;
                      _calculateCosts();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an ornament type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (in grams)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _calculateCosts(),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter weight';
                    }
                    if (double.tryParse(value!) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _makingChargesController,
                  decoration: InputDecoration(
                    labelText: 'Making Charges (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _calculateCosts(),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _cgstController,
                  decoration: InputDecoration(
                    labelText: 'CGST (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _calculateCosts(),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _sgstController,
                  decoration: InputDecoration(
                    labelText: 'SGST (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _calculateCosts(),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(
                    labelText: 'Discount (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _calculateCosts(),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _additionalChargesController,
                  decoration: InputDecoration(
                    labelText: 'Additional Charges',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _calculateCosts(),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Order Preview'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Divider(),
                _buildCostRow('Total Amount', _totalAmount, isTotal: true),
              ],
            ),
          ),
        ],
      ),
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
    super.dispose();
  }
}
