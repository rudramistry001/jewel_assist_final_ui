class ClickData {
  final int totalClicks;
  final int todayClicks;
  final List<DailyClickData> weeklyData;
  final List<BitlinkData> topBitlinks;

  ClickData({
    required this.totalClicks,
    required this.todayClicks,
    required this.weeklyData,
    required this.topBitlinks,
  });

  factory ClickData.fromJson(Map<String, dynamic> json) {
    return ClickData(
      totalClicks: json['totalClicks'] as int,
      todayClicks: json['todayClicks'] as int,
      weeklyData: (json['weeklyData'] as List)
          .map((data) => DailyClickData.fromJson(data))
          .toList(),
      topBitlinks: (json['topBitlinks'] as List)
          .map((data) => BitlinkData.fromJson(data))
          .toList(),
    );
  }
}

class DailyClickData {
  final DateTime date;
  final int clicks;

  DailyClickData({
    required this.date,
    required this.clicks,
  });

  factory DailyClickData.fromJson(Map<String, dynamic> json) {
    return DailyClickData(
      date: DateTime.parse(json['date'] as String),
      clicks: json['clicks'] as int,
    );
  }
}

class BitlinkData {
  final String id;
  final String title;
  final String url;
  final int clicks;
  final String iconCode;
  final String dateRange;

  BitlinkData({
    required this.id,
    required this.title,
    required this.url,
    required this.clicks,
    required this.iconCode,
    required this.dateRange,
  });

  factory BitlinkData.fromJson(Map<String, dynamic> json) {
    return BitlinkData(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      clicks: json['clicks'] as int,
      iconCode: json['iconCode'] as String,
      dateRange: json['dateRange'] as String,
    );
  }
} 