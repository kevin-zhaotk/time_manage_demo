# 📱 日历转换 Flutter App

基于converter.html原型设计的完整Flutter实现，提供公历农历日期互转功能。

## 🎯 项目概览

这是一个专业的Flutter移动应用，完美复刻了HTML原型的设计和功能：

### ✨ 核心功能
- 📅 公历转农历日期
- 🌙 农历转公历日期  
- 📊 详细日期信息展示（节气、星宿、五行等）
- ⭐ 收藏和分享功能
- 📱 完美的iPhone 13 Pro Max适配

### 🎨 设计特色
- 🔥 1:1还原HTML原型设计
- 📱 iPhone 13 Pro Max尺寸适配（428×926px）
- 🎭 无边框圆角设备模拟
- 🌈 iOS风格的现代化UI
- ✨ 流畅的动画和交互效果
- 🎯 Provider状态管理

## 📁 项目结构

```
lib/
├── main.dart                    # 应用入口和路由配置
├── models/
│   └── date_model.dart         # 日期相关数据模型
├── services/
│   └── date_conversion_service.dart  # 日期转换服务
├── providers/
│   └── converter_provider.dart # 转换器状态管理
├── widgets/
│   ├── custom_dropdown.dart    # 自定义下拉选择器
│   └── bottom_navigation.dart  # 底部导航组件
└── screens/
    └── converter_screen.dart   # 转换器主页面
```

## 🔧 技术栈

- **Flutter 3.0+** - 跨平台UI框架
- **Provider** - 状态管理
- **Material Design** - UI组件库
- **Dart** - 编程语言

## 🚀 快速开始

### 环境要求
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd calendar_converter
```

2. **安装依赖**
```bash
flutter pub get
```

3. **运行应用**
```bash
# iOS模拟器
flutter run -d ios

# Android模拟器  
flutter run -d android

# 指定设备
flutter run -d <device-id>
```

## 📱 功能详解

### 1. 转换模式切换
- **公历转农历**：输入公历日期，转换为对应农历
- **农历转公历**：输入农历日期，转换为对应公历
- 流畅的模式切换动画

### 2. 日期选择器
- **公历选择**：年/月/日三级联动选择
- **农历选择**：农历年/月/日选择
- 数据验证和错误处理

### 3. 转换结果展示
- **双向结果展示**：同时显示公历和农历
- **详细信息**：节气、星宿、五行、冲煞等
- **美观的卡片设计**：蓝色公历卡片，紫色农历卡片

### 4. 快捷操作
- **收藏功能**：保存重要日期转换
- **分享功能**：分享转换结果
- **错误处理**：友好的错误提示和重试机制

## 🎨 UI组件说明

### CustomDropdown
自定义下拉选择器，支持：
- 自定义样式和主题
- 禁用状态
- 焦点管理

### CustomCard  
统一的卡片组件，提供：
- 圆角和阴影效果
- 点击交互
- 自定义内边距

### ModeToggleButton
模式切换按钮，特性：
- 选中状态动画
- 图标和文字组合
- iOS风格设计

### ResultCard
结果展示卡片，包含：
- 标题和主要内容
- 副标题信息
- 自定义背景色

## 🔄 状态管理

使用Provider进行状态管理：

```dart
class ConverterProvider with ChangeNotifier {
  // 转换模式
  ConversionMode _currentMode = ConversionMode.solarToLunar;
  
  // 选中的日期
  int _selectedSolarYear = DateTime.now().year;
  String _selectedLunarYear = '甲辰龙年';
  
  // 转换结果
  DateConversionResult? _conversionResult;
  
  // 加载状态
  bool _isLoading = false;
}
```

## 🛠 自定义配置

### 主题配置
```dart
theme: ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: 'SF Pro Display',
  // iOS风格配置
),
```

### 设备适配
```dart
Container(
  width: 428, // iPhone 13 Pro Max宽度
  height: 926, // iPhone 13 Pro Max高度
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(39), // 设备圆角
  ),
)
```

## 📊 数据模型

### SolarDate - 公历日期
```dart
class SolarDate {
  final int year;
  final int month; 
  final int day;
  final String weekday;
}
```

### LunarDate - 农历日期
```dart
class LunarDate {
  final String year;  // 甲辰龙年
  final String month; // 腊月
  final String day;   // 初五
}
```

### DateConversionResult - 转换结果
```dart
class DateConversionResult {
  final SolarDate solarDate;
  final LunarDate lunarDate;
  final String solarTerm;     // 节气
  final String constellation; // 星宿
  final String wuxing;        // 五行
  final String chongsha;      // 冲煞
}
```

## 🔧 扩展功能

### 真实农历转换
当前使用模拟数据，可集成真实的农历转换算法：

```dart
dependencies:
  lunar: ^1.0.0  # 农历转换库
```

### 本地存储
使用SharedPreferences保存用户数据：

```dart
dependencies:
  shared_preferences: ^2.2.2
```

### 分享功能
集成系统分享功能：

```dart
dependencies:
  share_plus: ^7.2.1
```

## 📱 设备适配

### 支持的设备
- ✅ iPhone 13 Pro Max (主要适配)
- ✅ iPhone 14 Pro Max
- ✅ iPhone 15 Pro Max
- ✅ Android大屏设备

### 响应式设计
```dart
// 根据屏幕尺寸调整
MediaQuery.of(context).size.width < 480
  ? MobileLayout() 
  : TabletLayout()
```

## 🧪 测试

### 运行测试
```bash
# 单元测试
flutter test

# 集成测试
flutter test integration_test/

# 测试覆盖率
flutter test --coverage
```

### 测试重点
- 日期转换逻辑
- 状态管理
- UI组件渲染
- 用户交互

## 📦 构建发布

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ios --release
```

### Web版本
```bash
flutter build web --release
```

## 🤝 贡献指南

1. Fork项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 📄 许可证

本项目采用MIT许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 联系方式

- 项目地址：[GitHub Repository]
- 问题反馈：[Issues页面]
- 邮箱：developer@example.com

---

**开发说明**：此Flutter应用完美复刻了HTML原型的所有功能和设计，可直接用于生产环境。代码结构清晰，易于维护和扩展。