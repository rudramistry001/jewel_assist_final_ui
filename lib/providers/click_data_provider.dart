import 'package:flutter/material.dart';
import 'dart:math';
import '../models/click_data.dart';

class ClickDataProvider extends ChangeNotifier {
  late ClickData _clickData;
  bool _isLoading = true;
  String? _error;

  ClickData get clickData => _clickData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ClickDataProvider() {
    fetchClickData();
  }

  Future<void> fetchClickData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _clickData = ClickData(
        totalClicks: 12345,
        todayClicks: 324,
        weeklyData: _generateMockWeeklyData(),
        topBitlinks: _generateMockBitlinks(),
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DailyClickData> _generateMockWeeklyData() {
    final now = DateTime.now();
    final List<DailyClickData> data = [];
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // Generate a random number between 5000 and 25000
      final clicks = 5000 + (20000 * (0.5 + 0.5 * _sinWave(i / 6))).round();
      data.add(DailyClickData(date: date, clicks: clicks));
    }
    
    return data;
  }

  // Helper function to create a sine wave pattern
  double _sinWave(double x) {
    return (1 + sin(x * 6.28)) / 2;
  }

  List<BitlinkData> _generateMockBitlinks() {
    return [
      BitlinkData(
        id: 'fr',
        title: 'freecodecamp',
        url: 'bit.ly/2Ixwsmw',
        clicks: 1234,
        iconCode: 'FR',
        dateRange: 'Jun 7 to May 19',
      ),
      BitlinkData(
        id: 'np',
        title: 'New Photos',
        url: 'bit.ly/23zJxyy',
        clicks: 823,
        iconCode: 'NP',
        dateRange: 'Jun 7 to May 19',
      ),
      BitlinkData(
        id: 'fs',
        title: 'freecodecamp',
        url: 'bit.ly/2Ixwsmw',
        clicks: 432,
        iconCode: 'FS',
        dateRange: 'Jun 7 to May 19',
      ),
    ];
  }

  void refreshData() {
    fetchClickData();
  }
} 