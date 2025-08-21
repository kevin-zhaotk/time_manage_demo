// 日期转换相关的数据模型

class SolarDate {
  final int year;
  final int month;
  final int day;
  final String weekday;

  SolarDate({
    required this.year,
    required this.month,
    required this.day,
    required this.weekday,
  });

  @override
  String toString() => '$year年$month月$day日';

  String get formattedDate => '$year年${month.toString().padLeft(2, '0')}月${day.toString().padLeft(2, '0')}日';
}

class LunarDate {
  final String year; // 甲辰龙年
  final String month; // 腊月
  final String day; // 初五
  final bool isLeapMonth;

  LunarDate({
    required this.year,
    required this.month,
    required this.day,
    this.isLeapMonth = false,
  });

  @override
  String toString() => '$month$day';

  String get fullString => '$year$month$day';
}

class DateConversionResult {
  final SolarDate solarDate;
  final LunarDate lunarDate;
  final String solarTerm; // 节气
  final String constellation; // 星宿
  final String wuxing; // 五行
  final String chongsha; // 冲煞
  final List<String> festivals; // 节日

  DateConversionResult({
    required this.solarDate,
    required this.lunarDate,
    required this.solarTerm,
    required this.constellation,
    required this.wuxing,
    required this.chongsha,
    this.festivals = const [],
  });
}

enum ConversionMode {
  solarToLunar, // 公历转农历
  lunarToSolar, // 农历转公历
}

// 预定义的选择器数据
class DatePickerData {
  // 公历年份选项
  static List<String> get solarYears {
    final currentYear = DateTime.now().year;
    return List.generate(20, (index) => '${currentYear - 10 + index}年');
  }

  // 公历月份选项
  static const List<String> solarMonths = [
    '1月', '2月', '3月', '4月', '5月', '6月',
    '7月', '8月', '9月', '10月', '11月', '12月'
  ];

  // 公历日期选项（简化版，实际需要根据月份动态生成）
  static List<String> getSolarDays(int month, int year) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (index) => '${index + 1}日');
  }

  // 农历年份选项
  static const List<String> lunarYears = [
    '甲辰龙年', '癸卯兔年', '壬寅虎年', '辛丑牛年', '庚子鼠年',
    '己亥猪年', '戊戌狗年', '丁酉鸡年', '丙申猴年', '乙未羊年'
  ];

  // 农历月份选项
  static const List<String> lunarMonths = [
    '正月', '二月', '三月', '四月', '五月', '六月',
    '七月', '八月', '九月', '十月', '冬月', '腊月'
  ];

  // 农历日期选项
  static const List<String> lunarDays = [
    '初一', '初二', '初三', '初四', '初五', '初六', '初七', '初八', '初九', '初十',
    '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十',
    '廿一', '廿二', '廿三', '廿四', '廿五', '廿六', '廿七', '廿八', '廿九', '三十'
  ];

  // 星期选项
  static const List<String> weekdays = [
    '星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'
  ];
}