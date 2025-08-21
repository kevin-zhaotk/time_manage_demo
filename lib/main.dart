// Flutter日历转换App主入口
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/converter_flutter_ui.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/converter_provider.dart';
import 'providers/home_provider.dart';
import 'providers/history_provider.dart';
import 'providers/settings_provider.dart';
import 'utils/constants.dart';
import 'utils/storage_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化本地存储
  await StorageUtils().init();
  
  runApp(const CalendarConverterApp());
}

class CalendarConverterApp extends StatelessWidget {
  const CalendarConverterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 设置状态栏样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ConverterProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const AppContainer(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/converter': (context) => const ConverterFlutterUI(),
          '/history': (context) => const HistoryScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return _createRoute(const HomeScreen());
            case '/converter':
              return _createRoute(const ConverterFlutterUI());
            case '/history':
              return _createRoute(const HistoryScreen());
            case '/settings':
              return _createRoute(const SettingsScreen());
            default:
              return _createRoute(const ConverterFlutterUI());
          }
        },
      ),
    );
  }

  // 创建页面转场动画
  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: AppConstants.animationDurationMedium,
    );
  }
}

// App容器，模拟iPhone设备外观
class AppContainer extends StatelessWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: AppConstants.deviceWidth,
          height: AppConstants.deviceHeight,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(AppConstants.deviceRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const ConverterFlutterUI(), // 默认显示转换器页面
        ),
      ),
    );
  }
}

// 占位页面 - 主页
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('主页')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              '主页功能开发中',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) => _handleNavigation(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '主页'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: '转换'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '记录'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/converter');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/history');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/settings');
        break;
    }
  }
}

// 占位页面 - 历史记录
class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('历史记录')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text(
              '历史记录功能开发中',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (index) => _handleNavigation(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '主页'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: '转换'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '记录'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/converter');
        break;
      case 2:
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/settings');
        break;
    }
  }
}

// 占位页面 - 设置
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 80, color: Colors.purple),
            SizedBox(height: 16),
            Text(
              '设置功能开发中',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (index) => _handleNavigation(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '主页'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: '转换'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '记录'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/converter');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/history');
        break;
      case 3:
        break;
    }
  }
}