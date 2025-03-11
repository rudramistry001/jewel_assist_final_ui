import 'package:flutter/material.dart';
import '../models/jewelry_stats.dart';
import 'dart:math';

class AnalyticsProvider extends ChangeNotifier {
  String _timeRange = 'Monthly';
  List<GoldRate> _goldRates = [];
  late JewelryStats _stats;
  final Random _random = Random();
  DateTimeRange? _selectedDateRange;

  AnalyticsProvider() {
    _initializeData();
  }

  void _initializeData() {
    final categoryRevenue = {
      'Rings': 125000.0,
      'Necklaces': 98000.0,
      'Earrings': 75000.0,
      'Bracelets': 65000.0,
      'Watches': 110000.0,
    };

    final recentOrders = List.generate(10, (index) {
      final categories = [
        'Rings',
        'Necklaces',
        'Earrings',
        'Bracelets',
        'Watches'
      ];
      final statuses = ['Completed', 'In Progress', 'Pending'];
      final amount = _random.nextDouble() * 5000 + 1000;

      return OrderStats(
        orderId: 'ORD${DateTime.now().year}${1000 + index}',
        customerName: 'Customer ${index + 1}',
        amount: amount,
        date: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
        status: statuses[_random.nextInt(statuses.length)],
        category: categories[_random.nextInt(categories.length)],
      );
    });

    _stats = JewelryStats(
      completedOrders: 847,
      ordersInProgress: 124,
      totalRevenue: 473000.0,
      goldRates: _generateDummyGoldRates(),
      monthlyGrowth: 15.7,
      categoryRevenue: categoryRevenue,
      recentOrders: recentOrders,
      totalCustomers: 1256,
      averageRating: 4.8,
    );
  }

  String get timeRange => _timeRange;
  JewelryStats get stats => _stats;
  List<GoldRate> get goldRates => _goldRates;
  DateTimeRange? get selectedDateRange => _selectedDateRange;

  void updateTimeRange(String range) {
    _timeRange = range;
    _goldRates = _generateDummyGoldRates();
    notifyListeners();
  }

  Future<void> refreshData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Update with new random data
    final newCompletedOrders = _stats.completedOrders + _random.nextInt(20);
    final newOrdersInProgress =
        _stats.ordersInProgress + _random.nextInt(10) - 5;
    final newTotalRevenue =
        _stats.totalRevenue * (1 + (_random.nextDouble() * 0.05));
    final newMonthlyGrowth = _randomInRange(10.0, 18.0);
    final newTotalCustomers = _stats.totalCustomers + _random.nextInt(30);

    // Update category revenue
    final newCategoryRevenue = Map<String, double>.from(_stats.categoryRevenue);
    for (final key in newCategoryRevenue.keys) {
      newCategoryRevenue[key] =
          newCategoryRevenue[key]! * (1 + (_random.nextDouble() * 0.08 - 0.02));
    }

    // Generate new recent orders
    final categories = [
      'Rings',
      'Necklaces',
      'Earrings',
      'Bracelets',
      'Watches'
    ];
    final statuses = ['Completed', 'In Progress', 'Pending'];
    final newRecentOrders = List.generate(10, (index) {
      final amount = _random.nextDouble() * 5000 + 1000;
      return OrderStats(
        orderId: 'ORD${DateTime.now().year}${2000 + index}',
        customerName: 'Customer ${_random.nextInt(100) + 1}',
        amount: amount,
        date: DateTime.now().subtract(Duration(days: _random.nextInt(10))),
        status: statuses[_random.nextInt(statuses.length)],
        category: categories[_random.nextInt(categories.length)],
      );
    });

    // Update stats
    _stats = JewelryStats(
      completedOrders: newCompletedOrders,
      ordersInProgress: newOrdersInProgress > 0 ? newOrdersInProgress : 1,
      totalRevenue: newTotalRevenue,
      goldRates: _generateDummyGoldRates(),
      monthlyGrowth: newMonthlyGrowth,
      categoryRevenue: newCategoryRevenue,
      recentOrders: newRecentOrders,
      totalCustomers: newTotalCustomers,
      averageRating: _randomInRange(4.5, 5.0),
    );

    notifyListeners();
  }

  void setDateRange(DateTimeRange dateRange) {
    _selectedDateRange = dateRange;
    notifyListeners();
  }

  List<GoldRate> _generateDummyGoldRates() {
    final now = DateTime.now();
    final rates = <GoldRate>[];
    double baseRate = 1850.0; // Base gold rate

    int daysToGenerate = _timeRange == 'Weekly'
        ? 7
        : _timeRange == 'Monthly'
            ? 30
            : _timeRange == 'Quarterly'
                ? 90
                : 365;

    for (var i = daysToGenerate; i >= 0; i--) {
      // Create more realistic fluctuations
      final volatility = 0.002; // 0.2% daily volatility
      final change = ((_random.nextDouble() - 0.5) * 2 * volatility * baseRate);
      baseRate += change;

      rates.add(GoldRate(
        date: now.subtract(Duration(days: i)),
        rate: baseRate,
        change: change,
      ));
    }

    _goldRates = rates;
    return rates;
  }

  // Helper method to generate random numbers within a range
  double _randomInRange(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  void updateOrder(OrderStats updatedOrder) {
    final index = _stats.recentOrders
        .indexWhere((order) => order.orderId == updatedOrder.orderId);

    if (index != -1) {
      final newOrders = List<OrderStats>.from(_stats.recentOrders);
      newOrders[index] = updatedOrder;

      _stats = JewelryStats(
        completedOrders: _stats.completedOrders,
        ordersInProgress: _stats.ordersInProgress,
        totalRevenue: _stats.totalRevenue,
        goldRates: _stats.goldRates,
        monthlyGrowth: _stats.monthlyGrowth,
        categoryRevenue: _stats.categoryRevenue,
        recentOrders: newOrders,
        totalCustomers: _stats.totalCustomers,
        averageRating: _stats.averageRating,
      );

      notifyListeners();
    }
  }
}
