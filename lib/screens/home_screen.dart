// 主页面
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/home_model.dart';
import '../providers/home_provider.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider()..initializeHomeData(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: Container(
        width: 428, // iPhone 13 Pro Max width
        height: 926, // iPhone 13 Pro Max height
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(39),
        ),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(37),
          ),
          child: Column(
            children: [
              // 状态栏
              const StatusBar(),
              
              // 主内容区域
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.errorMessage != null) {
                      return _buildErrorView(provider);
                    }

                    return RefreshIndicator(
                      onRefresh: provider.refresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 问候语和日期
                            _buildGreetingSection(provider),
                            
                            // 今日信息卡片
                            _buildTodayInfoCard(provider),
                            
                            // 快速功能
                            _buildQuickActions(),
                            
                            // 节气日历
                            _buildSolarTermsSection(provider),
                            
                            // 传统节日
                            _buildFestivalsSection(provider),
                            
                            const SizedBox(height: 100), // 底部导航空间
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 0,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildErrorView(HomeProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              '加载失败',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                provider.clearError();
                provider.initializeHomeData();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingSection(HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider.getGreeting(),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            provider.todayInfo?.solarDate.formattedDate ?? '',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          if (provider.getTodaySpecialInfo() != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                provider.getTodaySpecialInfo()!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTodayInfoCard(HomeProvider provider) {
    final todayInfo = provider.todayInfo;
    if (todayInfo == null) return const SizedBox.shrink();

    return CustomCard(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF9A9E),
              Color(0xFFFECFEF),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 公历信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todayInfo.solarDate.formattedDate,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '公历 · ${todayInfo.solarDate.weekday}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Text(
                  todayInfo.weatherIcon,
                  style: const TextStyle(fontSize: 48),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 分割线
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.2),
            ),
            
            const SizedBox(height: 16),
            
            // 农历信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todayInfo.lunarDate.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      todayInfo.lunarDate.year,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      todayInfo.currentSolarTerm,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '已过 ${todayInfo.solarTermDaysPassed} 天',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            '快速转换',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Row(
          children: QuickActions.actions.map((action) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action == QuickActions.actions.last ? 0 : 12,
                ),
                child: _buildQuickActionCard(action),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildQuickActionCard(QuickAction action) {
    Color iconColor;
    switch (action.color) {
      case 'blue':
        iconColor = Colors.blue.shade500;
        break;
      case 'green':
        iconColor = Colors.green.shade500;
        break;
      default:
        iconColor = Colors.grey.shade500;
    }

    IconData iconData;
    switch (action.icon) {
      case 'swap_horiz':
        iconData = Icons.swap_horiz;
        break;
      case 'history':
        iconData = Icons.history;
        break;
      default:
        iconData = Icons.help_outline;
    }

    return CustomCard(
      margin: EdgeInsets.zero,
      onTap: () {
        // 处理导航
        // Navigator.pushNamed(context, action.route);
      },
      child: Column(
        children: [
          Icon(
            iconData,
            size: 32,
            color: iconColor,
          ),
          const SizedBox(height: 12),
          Text(
            action.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            action.subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolarTermsSection(HomeProvider provider) {
    if (provider.upcomingSolarTerms.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '节气日历',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(Icons.eco, color: Colors.green.shade500),
            ],
          ),
          const SizedBox(height: 16),
          ...provider.upcomingSolarTerms.take(3).map((term) {
            return _buildSolarTermItem(term);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSolarTermItem(SolarTermInfo term) {
    Color badgeColor;
    Color badgeTextColor;
    
    switch (term.statusColor) {
      case 'orange':
        badgeColor = Colors.orange.shade100;
        badgeTextColor = Colors.orange.shade600;
        break;
      case 'blue':
        badgeColor = Colors.blue.shade100;
        badgeTextColor = Colors.blue.shade600;
        break;
      default:
        badgeColor = Colors.grey.shade100;
        badgeTextColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                term.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                term.formattedDate,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              term.timeUntilText,
              style: TextStyle(
                fontSize: 12,
                color: badgeTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFestivalsSection(HomeProvider provider) {
    if (provider.upcomingFestivals.isEmpty) {
      return const SizedBox.shrink();
    }

    final nextFestival = provider.upcomingFestivals.first;

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '传统节日',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(Icons.card_giftcard, color: Colors.red.shade500),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade100),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nextFestival.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nextFestival.type == 'lunar' ? '农历节日' : '公历节日',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextFestival.formattedDate,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red.shade500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      nextFestival.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 4),
                    if (nextFestival.daysUntil > 0) ...[
                      Text(
                        '${nextFestival.daysUntil}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade600,
                        ),
                      ),
                      Text(
                        '天后',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade500,
                        ),
                      ),
                    ] else if (nextFestival.daysUntil == 0) ...[
                      Text(
                        '今天',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // 当前页面，无需操作
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