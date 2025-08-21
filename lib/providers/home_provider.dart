// 主页状态管理
import 'package:flutter/material.dart';
import '../models/date_model.dart';
import '../models/home_model.dart';
import '../services/date_conversion_service.dart';

class HomeProvider with ChangeNotifier {
  final DateConversionService _conversionService = DateConversionService();

  // 今日信息
  TodayInfo? _todayInfo;
  TodayInfo? get todayInfo => _todayInfo;

  // 即将到来的节气
  List<SolarTermInfo> _upcomingSolarTerms = [];
  List<SolarTermInfo> get upcomingSolarTerms => _upcomingSolarTerms;

  // 即将到来的节日
  List<FestivalInfo> _upcomingFestivals = [];
  List<FestivalInfo> get upcomingFestivals => _upcomingFestivals;

  // 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 初始化主页数据
  Future<void> initializeHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadTodayInfo(),
        _loadSolarTerms(),
        _loadFestivals(),
      ]);
    } catch (e) {
      _errorMessage = '加载数据失败：${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 加载今日信息
  Future<void> _loadTodayInfo() async {
    final now = DateTime.now();
    
    // 创建今日公历日期
    final solarDate = SolarDate(
      year: now.year,
      month: now.month,
      day: now.day,
      weekday: _conversionService.getWeekday(now),
    );

    // 转换为农历日期（使用模拟数据）
    final conversionResult = await _conversionService.solarToLunar(solarDate);
    
    // 获取当前节气信息
    final currentSolarTerm = conversionResult.solarTerm;
    final solarTermDaysPassed = _calculateSolarTermDaysPassed(now);

    _todayInfo = TodayInfo(
      solarDate: solarDate,
      lunarDate: conversionResult.lunarDate,
      currentSolarTerm: currentSolarTerm,
      solarTermDaysPassed: solarTermDaysPassed,
      weatherIcon: _getWeatherIcon(now),
      todayFestivals: conversionResult.festivals,
    );
  }

  // 加载节气信息
  Future<void> _loadSolarTerms() async {
    _upcomingSolarTerms = SolarTerms.getUpcomingTerms();
  }

  // 加载节日信息
  Future<void> _loadFestivals() async {
    _upcomingFestivals = Festivals.getUpcomingFestivals();
  }

  // 计算当前节气已过天数
  int _calculateSolarTermDaysPassed(DateTime now) {
    // 简化实现，返回模拟数据
    return 6;
  }

  // 获取天气图标
  String _getWeatherIcon(DateTime now) {
    // 根据季节返回不同图标
    final month = now.month;
    if (month >= 3 && month <= 5) return '🌸'; // 春季
    if (month >= 6 && month <= 8) return '☀️'; // 夏季
    if (month >= 9 && month <= 11) return '🍂'; // 秋季
    return '❄️'; // 冬季
  }

  // 刷新数据
  Future<void> refresh() async {
    await initializeHomeData();
  }

  // 获取问候语
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '夜深了';
    if (hour < 12) return '早上好';
    if (hour < 14) return '中午好';
    if (hour < 18) return '下午好';
    if (hour < 22) return '晚上好';
    return '夜深了';
  }

  // 获取今日特殊信息
  String? getTodaySpecialInfo() {
    if (_todayInfo?.todayFestivals.isNotEmpty == true) {
      return '今天是${_todayInfo!.todayFestivals.first}';
    }
    
    // 检查是否是节气
    final todayTerms = _upcomingSolarTerms.where((term) => term.daysUntil == 0).toList();
    if (todayTerms.isNotEmpty) {
      return '今天是${todayTerms.first.name}';
    }

    return null;
  }

  // 获取下一个重要日期
  String? getNextImportantDate() {
    // 优先显示即将到来的节日
    final nextFestival = _upcomingFestivals.where((f) => f.daysUntil > 0).firstOrNull;
    if (nextFestival != null) {
      return '${nextFestival.name}还有${nextFestival.daysUntil}天';
    }

    // 其次显示即将到来的节气
    final nextTerm = _upcomingSolarTerms.where((t) => t.daysUntil > 0).firstOrNull;
    if (nextTerm != null) {
      return '${nextTerm.name}还有${nextTerm.daysUntil}天';
    }

    return null;
  }

  // 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

// 扩展方法
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}