class JewelryStats {
  final int completedOrders;
  final int ordersInProgress;
  final double totalRevenue;
  final List<GoldRate> goldRates;
  final double monthlyGrowth;
  final Map<String, double> categoryRevenue;
  final List<OrderStats> recentOrders;
  final int totalCustomers;
  final double averageRating;

  JewelryStats({
    required this.completedOrders,
    required this.ordersInProgress,
    required this.totalRevenue,
    required this.goldRates,
    required this.monthlyGrowth,
    required this.categoryRevenue,
    required this.recentOrders,
    required this.totalCustomers,
    required this.averageRating,
  });
}

class GoldRate {
  final DateTime date;
  final double rate;
  final double change;

  GoldRate({
    required this.date,
    required this.rate,
    required this.change,
  });
}

class OrderStats {
  final String orderId;
  final String customerName;
  final double amount;
  final DateTime date;
  final String status;
  final String category;

  OrderStats({
    required this.orderId,
    required this.customerName,
    required this.amount,
    required this.date,
    required this.status,
    required this.category,
  });
}
