// 转换器页面的状态管理
import 'package:flutter/material.dart';
import '../models/date_model.dart';
import '../services/date_conversion_service.dart';

class ConverterProvider with ChangeNotifier {
  final DateConversionService _conversionService = DateConversionService();

  // 当前转换模式
  ConversionMode _currentMode = ConversionMode.solarToLunar;
  ConversionMode get currentMode => _currentMode;

  // 选中的公历日期
  int _selectedSolarYear = DateTime.now().year;
  int _selectedSolarMonth = DateTime.now().month;
  int _selectedSolarDay = DateTime.now().day;

  int get selectedSolarYear => _selectedSolarYear;
  int get selectedSolarMonth => _selectedSolarMonth;
  int get selectedSolarDay => _selectedSolarDay;

  // 选中的农历日期
  String _selectedLunarYear = '甲辰龙年';
  String _selectedLunarMonth = '腊月';
  String _selectedLunarDay = '初五';

  String get selectedLunarYear => _selectedLunarYear;
  String get selectedLunarMonth => _selectedLunarMonth;
  String get selectedLunarDay => _selectedLunarDay;

  // 转换结果
  DateConversionResult? _conversionResult;
  DateConversionResult? get conversionResult => _conversionResult;

  // 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 切换转换模式
  void switchMode(ConversionMode mode) {
    if (_currentMode != mode) {
      _currentMode = mode;
      _conversionResult = null;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // 设置公历日期
  void setSolarDate({int? year, int? month, int? day}) {
    if (year != null) _selectedSolarYear = year;
    if (month != null) _selectedSolarMonth = month;
    if (day != null) _selectedSolarDay = day;
    notifyListeners();
  }

  // 设置农历日期
  void setLunarDate({String? year, String? month, String? day}) {
    if (year != null) _selectedLunarYear = year;
    if (month != null) _selectedLunarMonth = month;
    if (day != null) _selectedLunarDay = day;
    notifyListeners();
  }

  // 执行转换
  Future<void> performConversion() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_currentMode == ConversionMode.solarToLunar) {
        // 验证公历日期
        if (!_conversionService.isValidSolarDate(_selectedSolarYear, _selectedSolarMonth, _selectedSolarDay)) {
          throw Exception('无效的公历日期');
        }

        final solarDate = SolarDate(
          year: _selectedSolarYear,
          month: _selectedSolarMonth,
          day: _selectedSolarDay,
          weekday: _conversionService.getWeekday(DateTime(_selectedSolarYear, _selectedSolarMonth, _selectedSolarDay)),
        );

        _conversionResult = await _conversionService.solarToLunar(solarDate);
      } else {
        // 验证农历日期
        if (!_conversionService.isValidLunarDate(_selectedLunarYear, _selectedLunarMonth, _selectedLunarDay)) {
          throw Exception('无效的农历日期');
        }

        final lunarDate = LunarDate(
          year: _selectedLunarYear,
          month: _selectedLunarMonth,
          day: _selectedLunarDay,
        );

        _conversionResult = await _conversionService.lunarToSolar(lunarDate);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _conversionResult = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 收藏当前结果
  void bookmarkResult() {
    if (_conversionResult != null) {
      // 这里应该保存到本地存储或数据库
      // 暂时只显示提示
      debugPrint('收藏成功: ${_conversionResult!.solarDate} <-> ${_conversionResult!.lunarDate}');
    }
  }

  // 分享当前结果
  void shareResult() {
    if (_conversionResult != null) {
      // 这里应该调用系统分享功能
      // 暂时只显示提示
      final shareText = '${_conversionResult!.solarDate.formattedDate} 对应 ${_conversionResult!.lunarDate.fullString}';
      debugPrint('分享内容: $shareText');
    }
  }

  // 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 重置到默认状态
  void reset() {
    _currentMode = ConversionMode.solarToLunar;
    _selectedSolarYear = DateTime.now().year;
    _selectedSolarMonth = DateTime.now().month;
    _selectedSolarDay = DateTime.now().day;
    _selectedLunarYear = '甲辰龙年';
    _selectedLunarMonth = '腊月';
    _selectedLunarDay = '初五';
    _conversionResult = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}