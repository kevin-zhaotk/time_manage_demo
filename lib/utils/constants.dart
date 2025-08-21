// 应用常量
import 'package:flutter/material.dart';

class AppConstants {
  // 应用信息
  static const String appName = '日历转换';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';
  
  // 设备尺寸 (iPhone 13 Pro Max)
  static const double deviceWidth = 428;
  static const double deviceHeight = 926;
  static const double deviceRadius = 39;
  static const double screenRadius = 37;
  static const double statusBarHeight = 47;
  static const double bottomNavHeight = 83;
  
  // 颜色
  static const Color primaryColor = Color(0xFF007AFF);
  static const Color backgroundColor = Color(0xFFF2F2F7);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Colors.black87;
  static const Color textSecondaryColor = Color(0xFF8E8E93);
  
  // 间距
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // 圆角
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  
  // 字体大小
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 22.0;
  static const double fontSizeTitle = 34.0;
  
  // 动画时长
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
  
  // 阴影
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
}

// 应用主题
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppConstants.primaryColor,
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      fontFamily: 'SF Pro Display',
      
      // AppBar主题
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: AppConstants.fontSizeXXLarge,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppConstants.textPrimaryColor,
        ),
      ),
      
      // 卡片主题
      cardTheme: CardTheme(
        color: AppConstants.cardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
      ),
      
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
      ),
      
      // 文字主题
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontSizeTitle,
          fontWeight: FontWeight.w700,
          color: AppConstants.textPrimaryColor,
        ),
        headlineLarge: TextStyle(
          fontSize: AppConstants.fontSizeXXLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: AppConstants.fontSizeXLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeLarge,
          color: AppConstants.textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          color: AppConstants.textSecondaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          color: AppConstants.textSecondaryColor,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF000000),
      cardColor: const Color(0xFF1C1C1E),
      textTheme: lightTheme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}

// 渐变色
class AppGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
    ],
  );
  
  static const LinearGradient lunar = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF9A9E),
      Color(0xFFFECFEF),
    ],
  );
  
  static const LinearGradient solar = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
    ],
  );
}

// 图标常量
class AppIcons {
  static const IconData home = Icons.home;
  static const IconData converter = Icons.swap_horiz;
  static const IconData history = Icons.history;
  static const IconData settings = Icons.settings;
  static const IconData calendar = Icons.calendar_today;
  static const IconData moon = Icons.nights_stay;
  static const IconData star = Icons.star;
  static const IconData bookmark = Icons.bookmark;
  static const IconData share = Icons.share;
  static const IconData refresh = Icons.refresh;
  static const IconData search = Icons.search;
  static const IconData clear = Icons.clear;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData up = Icons.keyboard_arrow_up;
  static const IconData down = Icons.keyboard_arrow_down;
  static const IconData left = Icons.keyboard_arrow_left;
  static const IconData right = Icons.keyboard_arrow_right;
}

// 字符串常量
class AppStrings {
  // 通用
  static const String loading = '加载中...';
  static const String retry = '重试';
  static const String cancel = '取消';
  static const String confirm = '确定';
  static const String save = '保存';
  static const String delete = '删除';
  static const String edit = '编辑';
  static const String share = '分享';
  static const String bookmark = '收藏';
  
  // 导航
  static const String home = '主页';
  static const String converter = '转换';
  static const String history = '记录';
  static const String settings = '设置';
  
  // 转换模式
  static const String solarToLunar = '公历转农历';
  static const String lunarToSolar = '农历转公历';
  
  // 错误信息
  static const String networkError = '网络连接失败';
  static const String loadError = '加载失败';
  static const String convertError = '转换失败';
  static const String invalidDate = '无效的日期';
  
  // 成功信息
  static const String bookmarked = '已收藏';
  static const String shared = '分享成功';
  static const String saved = '保存成功';
  static const String deleted = '删除成功';
}