class Order {
  final String orderId;
  final String customerName;
  final String phoneNumber;
  final DateTime orderDate;
  final String metalType;
  final double weight;
  final String ornamentType;
  final bool hasCustomDesign;
  final String? customDesign;
  final double metalCost;
  final double makingCharges;
  final double makingChargesAmount;
  final double? customDesignCharges;
  final double cgst;
  final double sgst;
  final double cgstAmount;
  final double sgstAmount;
  final double additionalCharges;
  final double discount;
  final double discountAmount;
  final double totalAmount;

  Order({
    required this.orderId,
    required this.customerName,
    required this.phoneNumber,
    required this.orderDate,
    required this.metalType,
    required this.weight,
    required this.ornamentType,
    required this.hasCustomDesign,
    this.customDesign,
    required this.metalCost,
    required this.makingCharges,
    required this.makingChargesAmount,
    this.customDesignCharges,
    required this.cgst,
    required this.sgst,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.additionalCharges,
    required this.discount,
    required this.discountAmount,
    required this.totalAmount,
  });

  // Create a factory constructor to create an Order from a Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] as String,
      customerName: map['customerName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      orderDate: DateTime.parse(map['orderDate'] as String),
      metalType: map['metalType'] as String,
      weight: map['weight'] as double,
      ornamentType: map['ornamentType'] as String,
      hasCustomDesign: map['hasCustomDesign'] as bool,
      customDesign: map['customDesign'] as String?,
      metalCost: map['metalCost'] as double,
      makingCharges: map['makingCharges'] as double,
      makingChargesAmount: map['makingChargesAmount'] as double,
      customDesignCharges: map['customDesignCharges'] as double?,
      cgst: map['cgst'] as double,
      sgst: map['sgst'] as double,
      cgstAmount: map['cgstAmount'] as double,
      sgstAmount: map['sgstAmount'] as double,
      additionalCharges: map['additionalCharges'] as double,
      discount: map['discount'] as double,
      discountAmount: map['discountAmount'] as double,
      totalAmount: map['totalAmount'] as double,
    );
  }

  // Convert Order to a Map
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'orderDate': orderDate.toIso8601String(),
      'metalType': metalType,
      'weight': weight,
      'ornamentType': ornamentType,
      'hasCustomDesign': hasCustomDesign,
      'customDesign': customDesign,
      'metalCost': metalCost,
      'makingCharges': makingCharges,
      'makingChargesAmount': makingChargesAmount,
      'customDesignCharges': customDesignCharges,
      'cgst': cgst,
      'sgst': sgst,
      'cgstAmount': cgstAmount,
      'sgstAmount': sgstAmount,
      'additionalCharges': additionalCharges,
      'discount': discount,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
    };
  }
} 