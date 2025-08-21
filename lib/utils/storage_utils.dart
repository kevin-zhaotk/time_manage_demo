// 本地存储工具类
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  // 单例模式
  static final StorageUtils _instance = StorageUtils._internal();
  factory StorageUtils() => _instance;
  StorageUtils._internal();

  // SharedPreferences实例（模拟）
  // SharedPreferences? _prefs;

  // 初始化
  Future<void> init() async {
    // _prefs = await SharedPreferences.getInstance();
  }

  // 保存字符串
  Future<bool> setString(String key, String value) async {
    try {
      // return await _prefs?.setString(key, value) ?? false;
      debugPrint('保存字符串: $key = $value');
      return true;
    } catch (e) {
      debugPrint('保存字符串失败: $e');
      return false;
    }
  }

  // 获取字符串
  String? getString(String key, {String? defaultValue}) {
    try {
      // return _prefs?.getString(key) ?? defaultValue;
      debugPrint('获取字符串: $key');
      return defaultValue;
    } catch (e) {
      debugPrint('获取字符串失败: $e');
      return defaultValue;
    }
  }

  // 保存整数
  Future<bool> setInt(String key, int value) async {
    try {
      // return await _prefs?.setInt(key, value) ?? false;
      debugPrint('保存整数: $key = $value');
      return true;
    } catch (e) {
      debugPrint('保存整数失败: $e');
      return false;
    }
  }

  // 获取整数
  int? getInt(String key, {int? defaultValue}) {
    try {
      // return _prefs?.getInt(key) ?? defaultValue;
      debugPrint('获取整数: $key');
      return defaultValue;
    } catch (e) {
      debugPrint('获取整数失败: $e');
      return defaultValue;
    }
  }

  // 保存布尔值
  Future<bool> setBool(String key, bool value) async {
    try {
      // return await _prefs?.setBool(key, value) ?? false;
      debugPrint('保存布尔值: $key = $value');
      return true;
    } catch (e) {
      debugPrint('保存布尔值失败: $e');
      return false;
    }
  }

  // 获取布尔值
  bool? getBool(String key, {bool? defaultValue}) {
    try {
      // return _prefs?.getBool(key) ?? defaultValue;
      debugPrint('获取布尔值: $key');
      return defaultValue;
    } catch (e) {
      debugPrint('获取布尔值失败: $e');
      return defaultValue;
    }
  }

  // 保存双精度浮点数
  Future<bool> setDouble(String key, double value) async {
    try {
      // return await _prefs?.setDouble(key, value) ?? false;
      debugPrint('保存浮点数: $key = $value');
      return true;
    } catch (e) {
      debugPrint('保存浮点数失败: $e');
      return false;
    }
  }

  // 获取双精度浮点数
  double? getDouble(String key, {double? defaultValue}) {
    try {
      // return _prefs?.getDouble(key) ?? defaultValue;
      debugPrint('获取浮点数: $key');
      return defaultValue;
    } catch (e) {
      debugPrint('获取浮点数失败: $e');
      return defaultValue;
    }
  }

  // 保存字符串列表
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      // return await _prefs?.setStringList(key, value) ?? false;
      debugPrint('保存字符串列表: $key = $value');
      return true;
    } catch (e) {
      debugPrint('保存字符串列表失败: $e');
      return false;
    }
  }

  // 获取字符串列表
  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    try {
      // return _prefs?.getStringList(key) ?? defaultValue;
      debugPrint('获取字符串列表: $key');
      return defaultValue;
    } catch (e) {
      debugPrint('获取字符串列表失败: $e');
      return defaultValue;
    }
  }

  // 保存JSON对象
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      return await setString(key, jsonString);
    } catch (e) {
      debugPrint('保存JSON失败: $e');
      return false;
    }
  }

  // 获取JSON对象
  Map<String, dynamic>? getJson(String key, {Map<String, dynamic>? defaultValue}) {
    try {
      final jsonString = getString(key);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return defaultValue;
    } catch (e) {
      debugPrint('获取JSON失败: $e');
      return defaultValue;
    }
  }

  // 删除键值对
  Future<bool> remove(String key) async {
    try {
      // return await _prefs?.remove(key) ?? false;
      debugPrint('删除键值对: $key');
      return true;
    } catch (e) {
      debugPrint('删除键值对失败: $e');
      return false;
    }
  }

  // 清空所有数据
  Future<bool> clear() async {
    try {
      // return await _prefs?.clear() ?? false;
      debugPrint('清空所有数据');
      return true;
    } catch (e) {
      debugPrint('清空所有数据失败: $e');
      return false;
    }
  }

  // 检查键是否存在
  bool containsKey(String key) {
    try {
      // return _prefs?.containsKey(key) ?? false;
      debugPrint('检查键是否存在: $key');
      return false;
    } catch (e) {
      debugPrint('检查键失败: $e');
      return false;
    }
  }

  // 获取所有键
  Set<String> getAllKeys() {
    try {
      // return _prefs?.getKeys() ?? <String>{};
      debugPrint('获取所有键');
      return <String>{};
    } catch (e) {
      debugPrint('获取所有键失败: $e');
      return <String>{};
    }
  }
}

// 存储键常量
class StorageKeys {
  // 用户设置
  static const String themeMode = 'theme_mode';
  static const String fontSize = 'font_size';
  static const String language = 'language';
  static const String autoSave = 'auto_save';
  static const String festivalNotification = 'festival_notification';
  static const String iCloudSync = 'icloud_sync';
  
  // 用户数据
  static const String userName = 'user_name';
  static const String userTitle = 'user_title';
  static const String queryCount = 'query_count';
  static const String bookmarkCount = 'bookmark_count';
  static const String usageDays = 'usage_days';
  static const String firstUseDate = 'first_use_date';
  
  // 应用数据
  static const String bookmarks = 'bookmarks';
  static const String historyItems = 'history_items';
  static const String recentSearches = 'recent_searches';
  static const String favoriteTerms = 'favorite_terms';
  
  // 缓存数据
  static const String solarTermsCache = 'solar_terms_cache';
  static const String festivalsCache = 'festivals_cache';
  static const String conversionCache = 'conversion_cache';
}