// 主页相关的数据模型
import 'date_model.dart';

class TodayInfo {
  final SolarDate solarDate;
  final LunarDate lunarDate;
  final String currentSolarTerm;
  final int solarTermDaysPassed;
  final String weatherIcon;
  final List<String> todayFestivals;

  TodayInfo({
    required this.solarDate,
    required this.lunarDate,
    required this.currentSolarTerm,
    required this.solarTermDaysPassed,
    this.weatherIcon = '☀️',
    this.todayFestivals = const [],
  });
}

class SolarTermInfo {
  final String name;
  final DateTime date;
  final int daysUntil;
  final String description;

  SolarTermInfo({
    required this.name,
    required this.date,
    required this.daysUntil,
    this.description = '',
  });

  String get formattedDate => '${date.month}月${date.day}日';
  
  String get timeUntilText {
    if (daysUntil == 0) return '今天';
    if (daysUntil == 1) return '明天';
    if (daysUntil < 0) return '已过${-daysUntil}天';
    return '${daysUntil}天后';
  }

  String get statusColor {
    if (daysUntil <= 0) return 'gray';
    if (daysUntil <= 7) return 'orange';
    if (daysUntil <= 30) return 'blue';
    return 'gray';
  }
}

class FestivalInfo {
  final String name;
  final DateTime date;
  final int daysUntil;
  final String type; // 'solar' 公历节日, 'lunar' 农历节日
  final String description;
  final String emoji;

  FestivalInfo({
    required this.name,
    required this.date,
    required this.daysUntil,
    required this.type,
    this.description = '',
    this.emoji = '🎉',
  });

  String get formattedDate => '${date.month}月${date.day}日';
  
  String get timeUntilText {
    if (daysUntil == 0) return '今天';
    if (daysUntil == 1) return '明天';
    if (daysUntil < 0) return '已过';
    return '${daysUntil}天后';
  }

  bool get isToday => daysUntil == 0;
  bool get isUpcoming => daysUntil > 0 && daysUntil <= 30;
}

class QuickAction {
  final String title;
  final String subtitle;
  final String icon;
  final String route;
  final String color;

  const QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
  });
}

// 预定义的快速操作
class QuickActions {
  static const List<QuickAction> actions = [
    QuickAction(
      title: '日期转换',
      subtitle: '公历农历互转',
      icon: 'swap_horiz',
      route: '/converter',
      color: 'blue',
    ),
    QuickAction(
      title: '查询记录',
      subtitle: '历史查询',
      icon: 'history',
      route: '/history',
      color: 'green',
    ),
  ];
}

// 节气数据
class SolarTerms {
  static const List<Map<String, dynamic>> terms2024 = [
    {'name': '小寒', 'date': '2024-01-06', 'description': '天气渐寒，尚未大冷'},
    {'name': '大寒', 'date': '2024-01-20', 'description': '一年中最寒冷的时候'},
    {'name': '立春', 'date': '2024-02-04', 'description': '春季开始'},
    {'name': '雨水', 'date': '2024-02-19', 'description': '降雨开始，雨量渐增'},
    {'name': '惊蛰', 'date': '2024-03-05', 'description': '春雷响起，蛰虫苏醒'},
    {'name': '春分', 'date': '2024-03-20', 'description': '昼夜平分，春季过半'},
    {'name': '清明', 'date': '2024-04-04', 'description': '天气清明，万物复苏'},
    {'name': '谷雨', 'date': '2024-04-19', 'description': '雨水增多，利于谷类生长'},
    {'name': '立夏', 'date': '2024-05-05', 'description': '夏季开始'},
    {'name': '小满', 'date': '2024-05-20', 'description': '小麦等作物籽粒开始饱满'},
    {'name': '芒种', 'date': '2024-06-05', 'description': '有芒作物成熟'},
    {'name': '夏至', 'date': '2024-06-21', 'description': '白昼最长'},
    {'name': '小暑', 'date': '2024-07-06', 'description': '天气开始炎热'},
    {'name': '大暑', 'date': '2024-07-22', 'description': '一年中最热的时候'},
    {'name': '立秋', 'date': '2024-08-07', 'description': '秋季开始'},
    {'name': '处暑', 'date': '2024-08-22', 'description': '暑气结束'},
    {'name': '白露', 'date': '2024-09-07', 'description': '天气转凉，露水增多'},
    {'name': '秋分', 'date': '2024-09-22', 'description': '昼夜平分，秋季过半'},
    {'name': '寒露', 'date': '2024-10-08', 'description': '露水更凉'},
    {'name': '霜降', 'date': '2024-10-23', 'description': '天气更冷，开始有霜'},
    {'name': '立冬', 'date': '2024-11-07', 'description': '冬季开始'},
    {'name': '小雪', 'date': '2024-11-22', 'description': '开始下雪'},
    {'name': '大雪', 'date': '2024-12-07', 'description': '雪量增大'},
    {'name': '冬至', 'date': '2024-12-21', 'description': '白昼最短'},
  ];

  static List<SolarTermInfo> getUpcomingTerms([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    final upcomingTerms = <SolarTermInfo>[];

    for (final term in terms2024) {
      final date = DateTime.parse(term['date']);
      final daysUntil = date.difference(now).inDays;
      
      if (daysUntil >= -30 && upcomingTerms.length < 6) {
        upcomingTerms.add(SolarTermInfo(
          name: term['name'],
          date: date,
          daysUntil: daysUntil,
          description: term['description'],
        ));
      }
    }

    return upcomingTerms;
  }
}

// 节日数据
class Festivals {
  static const List<Map<String, dynamic>> festivals2024 = [
    {'name': '春节', 'date': '2024-02-10', 'type': 'lunar', 'emoji': '🧧'},
    {'name': '元宵节', 'date': '2024-02-24', 'type': 'lunar', 'emoji': '🏮'},
    {'name': '清明节', 'date': '2024-04-04', 'type': 'solar', 'emoji': '🌿'},
    {'name': '劳动节', 'date': '2024-05-01', 'type': 'solar', 'emoji': '⚒️'},
    {'name': '端午节', 'date': '2024-06-10', 'type': 'lunar', 'emoji': '🚣'},
    {'name': '中秋节', 'date': '2024-09-17', 'type': 'lunar', 'emoji': '🌕'},
    {'name': '国庆节', 'date': '2024-10-01', 'type': 'solar', 'emoji': '🇨🇳'},
    {'name': '重阳节', 'date': '2024-10-11', 'type': 'lunar', 'emoji': '🍂'},
  ];

  static List<FestivalInfo> getUpcomingFestivals([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    final upcomingFestivals = <FestivalInfo>[];

    for (final festival in festivals2024) {
      final date = DateTime.parse(festival['date']);
      final daysUntil = date.difference(now).inDays;
      
      if (daysUntil >= -7 && upcomingFestivals.length < 3) {
        upcomingFestivals.add(FestivalInfo(
          name: festival['name'],
          date: date,
          daysUntil: daysUntil,
          type: festival['type'],
          emoji: festival['emoji'],
        ));
      }
    }

    return upcomingFestivals;
  }
}