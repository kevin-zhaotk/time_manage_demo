// 设置页面相关数据模型

class UserStats {
  final int queryCount;
  final int bookmarkCount;
  final int usageDays;
  final DateTime firstUseDate;

  UserStats({
    required this.queryCount,
    required this.bookmarkCount,
    required this.usageDays,
    required this.firstUseDate,
  });

  String get formattedFirstUse => 
      '${firstUseDate.year}年${firstUseDate.month}月${firstUseDate.day}日';
}

class UserProfile {
  final String name;
  final String title;
  final String? avatar;
  final UserStats stats;

  UserProfile({
    required this.name,
    required this.title,
    this.avatar,
    required this.stats,
  });
}

enum ThemeMode {
  light,
  dark,
  system,
}

enum FontSize {
  small,
  standard,
  large,
  extraLarge,
}

enum Language {
  chinese,
  english,
}

class DisplaySettings {
  final ThemeMode themeMode;
  final FontSize fontSize;
  final Language language;

  DisplaySettings({
    this.themeMode = ThemeMode.light,
    this.fontSize = FontSize.standard,
    this.language = Language.chinese,
  });

  String get themeModeText {
    switch (themeMode) {
      case ThemeMode.light:
        return '浅色模式';
      case ThemeMode.dark:
        return '深色模式';
      case ThemeMode.system:
        return '跟随系统';
    }
  }

  String get fontSizeText {
    switch (fontSize) {
      case FontSize.small:
        return '小';
      case FontSize.standard:
        return '标准';
      case FontSize.large:
        return '大';
      case FontSize.extraLarge:
        return '特大';
    }
  }

  String get languageText {
    switch (language) {
      case Language.chinese:
        return '简体中文';
      case Language.english:
        return 'English';
    }
  }
}

class FunctionSettings {
  final bool autoSave;
  final bool festivalNotification;
  final bool iCloudSync;

  FunctionSettings({
    this.autoSave = true,
    this.festivalNotification = false,
    this.iCloudSync = true,
  });
}

class SettingItem {
  final String title;
  final String? subtitle;
  final String iconName;
  final String iconColor;
  final SettingItemType type;
  final dynamic value;
  final VoidCallback? onTap;

  SettingItem({
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.iconColor,
    required this.type,
    this.value,
    this.onTap,
  });
}

enum SettingItemType {
  toggle,
  navigation,
  action,
}

class SettingSection {
  final String title;
  final List<SettingItem> items;

  SettingSection({
    required this.title,
    required this.items,
  });
}

// 预定义的设置项目
class DefaultSettings {
  static List<SettingSection> getDisplaySettings(DisplaySettings displaySettings) {
    return [
      SettingSection(
        title: '显示设置',
        items: [
          SettingItem(
            title: '主题模式',
            subtitle: displaySettings.themeModeText,
            iconName: 'palette',
            iconColor: 'blue',
            type: SettingItemType.toggle,
            value: displaySettings.themeMode == ThemeMode.light,
          ),
          SettingItem(
            title: '字体大小',
            subtitle: displaySettings.fontSizeText,
            iconName: 'font_download',
            iconColor: 'green',
            type: SettingItemType.navigation,
          ),
          SettingItem(
            title: '语言',
            subtitle: displaySettings.languageText,
            iconName: 'language',
            iconColor: 'purple',
            type: SettingItemType.navigation,
          ),
        ],
      ),
    ];
  }

  static List<SettingSection> getFunctionSettings(FunctionSettings functionSettings) {
    return [
      SettingSection(
        title: '功能设置',
        items: [
          SettingItem(
            title: '自动保存查询',
            subtitle: '自动保存转换记录',
            iconName: 'save',
            iconColor: 'orange',
            type: SettingItemType.toggle,
            value: functionSettings.autoSave,
          ),
          SettingItem(
            title: '节日提醒',
            subtitle: '重要节日推送提醒',
            iconName: 'notifications',
            iconColor: 'red',
            type: SettingItemType.toggle,
            value: functionSettings.festivalNotification,
          ),
          SettingItem(
            title: 'iCloud同步',
            subtitle: '同步收藏和设置',
            iconName: 'cloud_sync',
            iconColor: 'teal',
            type: SettingItemType.toggle,
            value: functionSettings.iCloudSync,
          ),
        ],
      ),
    ];
  }

  static List<SettingSection> get otherSettings {
    return [
      SettingSection(
        title: '其他',
        items: [
          SettingItem(
            title: '清除缓存',
            subtitle: '清理应用缓存数据',
            iconName: 'delete_sweep',
            iconColor: 'yellow',
            type: SettingItemType.action,
          ),
          SettingItem(
            title: '意见反馈',
            subtitle: '帮助我们改进产品',
            iconName: 'feedback',
            iconColor: 'indigo',
            type: SettingItemType.navigation,
          ),
          SettingItem(
            title: '关于我们',
            subtitle: '版本 1.0.0',
            iconName: 'info',
            iconColor: 'pink',
            type: SettingItemType.navigation,
          ),
          SettingItem(
            title: '隐私政策',
            subtitle: '了解数据使用方式',
            iconName: 'security',
            iconColor: 'gray',
            type: SettingItemType.navigation,
          ),
        ],
      ),
    ];
  }
}

// 应用信息
class AppInfo {
  static const String name = '日历转换';
  static const String version = '1.0.0';
  static const String buildNumber = '1';
  static const String copyright = '© 2024 All Rights Reserved';
  static const String description = '专业的公历农历日期转换工具';
}