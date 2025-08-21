// 日期工具类
import '../models/date_model.dart';

class DateUtils {
  // 获取星期几的中文名称
  static String getWeekdayName(DateTime date) {
    const weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return weekdays[date.weekday - 1];
  }

  // 获取月份的中文名称
  static String getMonthName(int month) {
    const months = ['一月', '二月', '三月', '四月', '五月', '六月',
                   '七月', '八月', '九月', '十月', '十一月', '十二月'];
    return months[month - 1];
  }

  // 获取农历月份名称
  static String getLunarMonthName(int month) {
    const lunarMonths = ['正月', '二月', '三月', '四月', '五月', '六月',
                        '七月', '八月', '九月', '十月', '冬月', '腊月'];
    return lunarMonths[month - 1];
  }

  // 获取农历日期名称
  static String getLunarDayName(int day) {
    const lunarDays = [
      '初一', '初二', '初三', '初四', '初五', '初六', '初七', '初八', '初九', '初十',
      '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十',
      '廿一', '廿二', '廿三', '廿四', '廿五', '廿六', '廿七', '廿八', '廿九', '三十'
    ];
    if (day >= 1 && day <= 30) {
      return lunarDays[day - 1];
    }
    return '$day';
  }

  // 格式化日期为字符串
  static String formatDate(DateTime date, {String format = 'yyyy年MM月dd日'}) {
    String result = format;
    result = result.replaceAll('yyyy', date.year.toString());
    result = result.replaceAll('MM', date.month.toString().padLeft(2, '0'));
    result = result.replaceAll('dd', date.day.toString().padLeft(2, '0'));
    result = result.replaceAll('M', date.month.toString());
    result = result.replaceAll('d', date.day.toString());
    return result;
  }

  // 格式化时间为字符串
  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    String result = format;
    result = result.replaceAll('HH', time.hour.toString().padLeft(2, '0'));
    result = result.replaceAll('mm', time.minute.toString().padLeft(2, '0'));
    result = result.replaceAll('ss', time.second.toString().padLeft(2, '0'));
    return result;
  }

  // 计算两个日期之间的天数差
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  // 判断是否为闰年
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  // 获取某个月的天数
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  // 获取今天的日期
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // 获取昨天的日期
  static DateTime get yesterday {
    return today.subtract(const Duration(days: 1));
  }

  // 获取明天的日期
  static DateTime get tomorrow {
    return today.add(const Duration(days: 1));
  }

  // 判断是否为今天
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  // 判断是否为昨天
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
           date.month == yesterday.month &&
           date.day == yesterday.day;
  }

  // 获取相对时间描述
  static String getRelativeTimeString(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return '刚刚';
        }
        return '${difference.inMinutes}分钟前';
      }
      return '${difference.inHours}小时前';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}周前';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}个月前';
    } else {
      return '${(difference.inDays / 365).floor()}年前';
    }
  }

  // 获取时间段描述
  static String getTimeRangeString(int daysUntil) {
    if (daysUntil == 0) return '今天';
    if (daysUntil == 1) return '明天';
    if (daysUntil == -1) return '昨天';
    if (daysUntil > 0) return '${daysUntil}天后';
    return '${-daysUntil}天前';
  }

  // 验证公历日期
  static bool isValidSolarDate(int year, int month, int day) {
    if (year < 1900 || year > 2100) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1) return false;
    
    final daysInMonth = getDaysInMonth(year, month);
    return day <= daysInMonth;
  }

  // 创建SolarDate对象
  static SolarDate createSolarDate(DateTime date) {
    return SolarDate(
      year: date.year,
      month: date.month,
      day: date.day,
      weekday: getWeekdayName(date),
    );
  }

  // 从SolarDate创建DateTime对象
  static DateTime dateTimeFromSolarDate(SolarDate solarDate) {
    return DateTime(solarDate.year, solarDate.month, solarDate.day);
  }

  // 获取年份范围
  static List<int> getYearRange({int? startYear, int? endYear}) {
    final currentYear = DateTime.now().year;
    final start = startYear ?? currentYear - 10;
    final end = endYear ?? currentYear + 10;
    
    return List.generate(end - start + 1, (index) => start + index);
  }

  // 获取生肖
  static String getZodiac(int year) {
    const zodiacs = ['鼠', '牛', '虎', '兔', '龙', '蛇', '马', '羊', '猴', '鸡', '狗', '猪'];
    return zodiacs[(year - 4) % 12];
  }

  // 获取天干地支
  static String getGanZhi(int year) {
    const gan = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    const zhi = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
    
    final ganIndex = (year - 4) % 10;
    final zhiIndex = (year - 4) % 12;
    
    return '${gan[ganIndex]}${zhi[zhiIndex]}';
  }

  // 获取节气信息
  static String getSolarTerm(DateTime date) {
    // 简化的节气计算，实际应用中需要更精确的算法
    final month = date.month;
    final day = date.day;
    
    if (month == 1) {
      if (day <= 5) return '小寒';
      if (day <= 20) return '大寒';
      return '立春';
    } else if (month == 2) {
      if (day <= 4) return '立春';
      if (day <= 19) return '雨水';
      return '惊蛰';
    } else if (month == 3) {
      if (day <= 5) return '惊蛰';
      if (day <= 20) return '春分';
      return '清明';
    } else if (month == 4) {
      if (day <= 4) return '清明';
      if (day <= 20) return '谷雨';
      return '立夏';
    } else if (month == 5) {
      if (day <= 5) return '立夏';
      if (day <= 21) return '小满';
      return '芒种';
    } else if (month == 6) {
      if (day <= 5) return '芒种';
      if (day <= 21) return '夏至';
      return '小暑';
    } else if (month == 7) {
      if (day <= 7) return '小暑';
      if (day <= 23) return '大暑';
      return '立秋';
    } else if (month == 8) {
      if (day <= 7) return '立秋';
      if (day <= 23) return '处暑';
      return '白露';
    } else if (month == 9) {
      if (day <= 7) return '白露';
      if (day <= 23) return '秋分';
      return '寒露';
    } else if (month == 10) {
      if (day <= 8) return '寒露';
      if (day <= 23) return '霜降';
      return '立冬';
    } else if (month == 11) {
      if (day <= 7) return '立冬';
      if (day <= 22) return '小雪';
      return '大雪';
    } else {
      if (day <= 7) return '大雪';
      if (day <= 22) return '冬至';
      return '小寒';
    }
  }
}