// 设置页面状态管理
import 'package:flutter/material.dart';
import '../models/settings_model.dart';

class SettingsProvider with ChangeNotifier {
  // 用户资料
  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  // 显示设置
  DisplaySettings _displaySettings = DisplaySettings();
  DisplaySettings get displaySettings => _displaySettings;

  // 功能设置
  FunctionSettings _functionSettings = FunctionSettings();
  FunctionSettings get functionSettings => _functionSettings;

  // 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 初始化设置数据
  Future<void> initializeSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadUserProfile(),
        _loadDisplaySettings(),
        _loadFunctionSettings(),
      ]);
    } catch (e) {
      _errorMessage = '加载设置失败：${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 加载用户资料
  Future<void> _loadUserProfile() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));
    
    final stats = UserStats(
      queryCount: 127,
      bookmarkCount: 8,
      usageDays: 45,
      firstUseDate: DateTime(2023, 12, 1),
    );

    _userProfile = UserProfile(
      name: '用户',
      title: '日历转换专家',
      stats: stats,
    );
  }

  // 加载显示设置
  Future<void> _loadDisplaySettings() async {
    // 模拟从本地存储加载
    await Future.delayed(const Duration(milliseconds: 200));
    
    _displaySettings = DisplaySettings(
      themeMode: ThemeMode.light,
      fontSize: FontSize.standard,
      language: Language.chinese,
    );
  }

  // 加载功能设置
  Future<void> _loadFunctionSettings() async {
    // 模拟从本地存储加载
    await Future.delayed(const Duration(milliseconds: 200));
    
    _functionSettings = FunctionSettings(
      autoSave: true,
      festivalNotification: false,
      iCloudSync: true,
    );
  }

  // 切换主题模式
  void toggleThemeMode() {
    final newThemeMode = _displaySettings.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    
    _displaySettings = DisplaySettings(
      themeMode: newThemeMode,
      fontSize: _displaySettings.fontSize,
      language: _displaySettings.language,
    );
    
    // 这里应该保存到本地存储
    _saveDisplaySettings();
    notifyListeners();
  }

  // 设置字体大小
  void setFontSize(FontSize fontSize) {
    _displaySettings = DisplaySettings(
      themeMode: _displaySettings.themeMode,
      fontSize: fontSize,
      language: _displaySettings.language,
    );
    
    _saveDisplaySettings();
    notifyListeners();
  }

  // 设置语言
  void setLanguage(Language language) {
    _displaySettings = DisplaySettings(
      themeMode: _displaySettings.themeMode,
      fontSize: _displaySettings.fontSize,
      language: language,
    );
    
    _saveDisplaySettings();
    notifyListeners();
  }

  // 切换自动保存
  void toggleAutoSave() {
    _functionSettings = FunctionSettings(
      autoSave: !_functionSettings.autoSave,
      festivalNotification: _functionSettings.festivalNotification,
      iCloudSync: _functionSettings.iCloudSync,
    );
    
    _saveFunctionSettings();
    notifyListeners();
  }

  // 切换节日提醒
  void toggleFestivalNotification() {
    _functionSettings = FunctionSettings(
      autoSave: _functionSettings.autoSave,
      festivalNotification: !_functionSettings.festivalNotification,
      iCloudSync: _functionSettings.iCloudSync,
    );
    
    _saveFunctionSettings();
    notifyListeners();
  }

  // 切换iCloud同步
  void toggleICloudSync() {
    _functionSettings = FunctionSettings(
      autoSave: _functionSettings.autoSave,
      festivalNotification: _functionSettings.festivalNotification,
      iCloudSync: !_functionSettings.iCloudSync,
    );
    
    _saveFunctionSettings();
    notifyListeners();
  }

  // 清除缓存
  Future<void> clearCache() async {
    // 模拟清除缓存过程
    await Future.delayed(const Duration(seconds: 1));
    
    // 这里应该清除实际的缓存数据
    debugPrint('缓存已清除');
  }

  // 保存显示设置到本地存储
  Future<void> _saveDisplaySettings() async {
    // 这里应该保存到SharedPreferences或其他本地存储
    debugPrint('保存显示设置: ${_displaySettings.themeModeText}');
  }

  // 保存功能设置到本地存储
  Future<void> _saveFunctionSettings() async {
    // 这里应该保存到SharedPreferences或其他本地存储
    debugPrint('保存功能设置: 自动保存=${_functionSettings.autoSave}');
  }

  // 获取所有设置分组
  List<SettingSection> getSettingSections() {
    return [
      ...DefaultSettings.getDisplaySettings(_displaySettings),
      ...DefaultSettings.getFunctionSettings(_functionSettings),
      ...DefaultSettings.otherSettings,
    ];
  }

  // 处理设置项点击
  void handleSettingTap(SettingItem item) {
    switch (item.title) {
      case '主题模式':
        toggleThemeMode();
        break;
      case '自动保存查询':
        toggleAutoSave();
        break;
      case '节日提醒':
        toggleFestivalNotification();
        break;
      case 'iCloud同步':
        toggleICloudSync();
        break;
      case '清除缓存':
        clearCache();
        break;
      default:
        debugPrint('点击了设置项: ${item.title}');
    }
  }

  // 获取设置项的当前值
  bool getToggleValue(String title) {
    switch (title) {
      case '主题模式':
        return _displaySettings.themeMode == ThemeMode.light;
      case '自动保存查询':
        return _functionSettings.autoSave;
      case '节日提醒':
        return _functionSettings.festivalNotification;
      case 'iCloud同步':
        return _functionSettings.iCloudSync;
      default:
        return false;
    }
  }

  // 刷新数据
  Future<void> refresh() async {
    await initializeSettings();
  }

  // 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 检查是否为深色模式
  bool get isDarkMode => _displaySettings.themeMode == ThemeMode.dark;

  // 获取当前字体缩放比例
  double get fontScale {
    switch (_displaySettings.fontSize) {
      case FontSize.small:
        return 0.8;
      case FontSize.standard:
        return 1.0;
      case FontSize.large:
        return 1.2;
      case FontSize.extraLarge:
        return 1.4;
    }
  }
}