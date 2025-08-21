// 历史记录相关数据模型
import 'date_model.dart';

class BookmarkItem {
  final String id;
  final String title;
  final String description;
  final DateConversionResult conversionResult;
  final DateTime createdAt;
  final String iconType;
  final String color;

  BookmarkItem({
    required this.id,
    required this.title,
    required this.description,
    required this.conversionResult,
    required this.createdAt,
    this.iconType = 'bookmark',
    this.color = 'blue',
  });

  String get formattedDate => '${createdAt.month}月${createdAt.day}日';
  
  String get conversionText => 
      '${conversionResult.solarDate.formattedDate} → ${conversionResult.lunarDate.fullString}';
}

class HistoryItem {
  final String id;
  final DateConversionResult conversionResult;
  final DateTime createdAt;
  final ConversionMode conversionMode;
  final bool isBookmarked;

  HistoryItem({
    required this.id,
    required this.conversionResult,
    required this.createdAt,
    required this.conversionMode,
    this.isBookmarked = false,
  });

  String get formattedDate => '${createdAt.month}月${createdAt.day}日';
  String get formattedTime => '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  
  String get primaryText {
    return conversionMode == ConversionMode.solarToLunar
        ? conversionResult.solarDate.formattedDate
        : conversionResult.lunarDate.fullString;
  }
  
  String get secondaryText {
    return conversionMode == ConversionMode.solarToLunar
        ? '${conversionResult.lunarDate.toString()} · ${conversionResult.lunarDate.year}'
        : '${conversionResult.solarDate.formattedDate} · ${conversionResult.solarDate.weekday}';
  }

  String get iconType {
    return conversionMode == ConversionMode.solarToLunar ? 'calendar' : 'moon';
  }

  String get iconColor {
    return conversionMode == ConversionMode.solarToLunar ? 'blue' : 'purple';
  }
}

class HistoryGroup {
  final String title;
  final String subtitle;
  final List<HistoryItem> items;

  HistoryGroup({
    required this.title,
    required this.subtitle,
    required this.items,
  });
}

// 预定义的收藏项目
class DefaultBookmarks {
  static List<BookmarkItem> get items => [
    BookmarkItem(
      id: 'birthday',
      title: '我的生日',
      description: '1995年8月15日 → 乙亥年七月二十',
      conversionResult: DateConversionResult(
        solarDate: SolarDate(year: 1995, month: 8, day: 15, weekday: '星期二'),
        lunarDate: LunarDate(year: '乙亥猪年', month: '七月', day: '二十'),
        solarTerm: '立秋',
        constellation: '房日兔',
        wuxing: '木',
        chongsha: '冲蛇',
      ),
      createdAt: DateTime(2024, 1, 10),
      iconType: 'birthday_cake',
      color: 'yellow',
    ),
    BookmarkItem(
      id: 'anniversary',
      title: '结婚纪念日',
      description: '2020年10月1日 → 庚子年八月十五',
      conversionResult: DateConversionResult(
        solarDate: SolarDate(year: 2020, month: 10, day: 1, weekday: '星期四'),
        lunarDate: LunarDate(year: '庚子鼠年', month: '八月', day: '十五'),
        solarTerm: '秋分',
        constellation: '心月狐',
        wuxing: '金',
        chongsha: '冲马',
      ),
      createdAt: DateTime(2024, 1, 8),
      iconType: 'heart',
      color: 'red',
    ),
  ];
}

// 模拟历史记录数据
class MockHistoryData {
  static List<HistoryItem> get recentItems => [
    HistoryItem(
      id: 'h1',
      conversionResult: DateConversionResult(
        solarDate: SolarDate(year: 2024, month: 1, day: 15, weekday: '星期一'),
        lunarDate: LunarDate(year: '甲辰龙年', month: '腊月', day: '初五'),
        solarTerm: '小寒',
        constellation: '角木蛟',
        wuxing: '木',
        chongsha: '冲鸡',
      ),
      createdAt: DateTime(2024, 1, 15, 15, 30),
      conversionMode: ConversionMode.solarToLunar,
      isBookmarked: true,
    ),
    HistoryItem(
      id: 'h2',
      conversionResult: DateConversionResult(
        solarDate: SolarDate(year: 2024, month: 1, day: 11, weekday: '星期四'),
        lunarDate: LunarDate(year: '甲辰龙年', month: '腊月', day: '初一'),
        solarTerm: '小寒',
        constellation: '斗木獬',
        wuxing: '土',
        chongsha: '冲羊',
      ),
      createdAt: DateTime(2024, 1, 15, 14, 25),
      conversionMode: ConversionMode.lunarToSolar,
    ),
    HistoryItem(
      id: 'h3',
      conversionResult: DateConversionResult(
        solarDate: SolarDate(year: 2024, month: 2, day: 10, weekday: '星期六'),
        lunarDate: LunarDate(year: '甲辰龙年', month: '正月', day: '初一'),
        solarTerm: '立春',
        constellation: '女土蝠',
        wuxing: '火',
        chongsha: '冲马',
        festivals: ['春节'],
      ),
      createdAt: DateTime(2024, 1, 15, 13, 45),
      conversionMode: ConversionMode.solarToLunar,
    ),
  ];

  static List<HistoryItem> get yesterdayItems => [
    HistoryItem(
      id: 'h4',
      conversionResult: DateConversionResult(
        solarDate: SolarDate(year: 2024, month: 1, day: 14, weekday: '星期日'),
        lunarDate: LunarDate(year: '甲辰龙年', month: '腊月', day: '初四'),
        solarTerm: '小寒',
        constellation: '牛金牛',
        wuxing: '水',
        chongsha: '冲猴',
      ),
      createdAt: DateTime(2024, 1, 14, 19, 20),
      conversionMode: ConversionMode.lunarToSolar,
    ),
    HistoryItem(
      id: 'h5',
      conversionResult: DateConversionResult(
        solarDate: SolarDate(year: 2024, month: 1, day: 6, weekday: '星期六'),
        lunarDate: LunarDate(year: '癸卯兔年', month: '冬月', day: '廿五'),
        solarTerm: '小寒',
        constellation: '虚日鼠',
        wuxing: '金',
        chongsha: '冲狗',
      ),
      createdAt: DateTime(2024, 1, 14, 16, 15),
      conversionMode: ConversionMode.solarToLunar,
    ),
  ];

  static List<HistoryGroup> get groupedHistory => [
    HistoryGroup(
      title: '最近查询',
      subtitle: '今天',
      items: recentItems,
    ),
    HistoryGroup(
      title: '昨天',
      subtitle: '1月14日',
      items: yesterdayItems,
    ),
  ];
}