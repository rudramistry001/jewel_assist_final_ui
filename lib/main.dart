import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'providers/click_data_provider.dart';
import 'providers/analytics_provider.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design size based on iPhone X
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ClickDataProvider()),
            ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
          ],
          child: MaterialApp(
            title: 'Jewel Assist',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A90E2)),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFF5F8FA),
            ),
            home: child,
          ),
        );
      },
      child: const MainNavigationScreen(),
    );
  }
}
