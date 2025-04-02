import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_constants.dart';
import 'home_screen.dart';
import 'analytics_screen.dart';
import 'create_order_screen.dart';
import 'detailed_orders_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  // Using a PageController to manage page transitions
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Method to handle navigation to a specific tab
  void navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
      // Animate to the selected page
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600;
    final isPad = screenSize.width >= 768;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Adapt the UI based on screen size
    final iconSize = isPad ? 28.0 : 24.0;
    final labelStyle = TextStyle(
      fontSize: isPad ? 14.sp : 12.sp,
      fontWeight: FontWeight.w500,
    );
    
    // For tablets/larger devices, use a more appropriate navigation layout
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: const [
          HomeScreen(),
          AnalyticsScreen(),
          CreateOrderScreen(),
          DetailedOrdersScreen(),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      // Adaptive bottom navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: navigateToTab,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.textSecondaryColor,
          selectedLabelStyle: labelStyle,
          unselectedLabelStyle: labelStyle,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          iconSize: iconSize,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              tooltip: 'Home Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Analytics',
              tooltip: 'Business Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Create Order',
              tooltip: 'Create New Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Orders',
              tooltip: 'View Orders',
            ),
          ],
        ),
      ),
      // Add floating action button for quick order creation (on larger screens)
      floatingActionButton: isTablet ? FloatingActionButton(
        onPressed: () => navigateToTab(2), // Navigate to Create Order tab
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
        tooltip: 'Create New Order',
      ) : null,
    );
  }
} 