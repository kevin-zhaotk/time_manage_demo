// 设置页面
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings_model.dart';
import '../providers/settings_provider.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/bottom_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider()..initializeSettings(),
      child: const _SettingsScreenContent(),
    );
  }
}

class _SettingsScreenContent extends StatelessWidget {
  const _SettingsScreenContent({Key? key}) : super(key: key);

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
                child: Consumer<SettingsProvider>(
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
                            // 标题栏
                            _buildAppBar(),
                            
                            // 用户信息卡片
                            _buildUserProfileCard(provider),
                            
                            // 设置分组
                            ...provider.getSettingSections().map(
                              (section) => _buildSettingSection(section, provider),
                            ),
                            
                            // 版本信息
                            _buildVersionInfo(),
                            
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
        currentIndex: 3,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildErrorView(SettingsProvider provider) {
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
                provider.initializeSettings();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              '设置',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(SettingsProvider provider) {
    final userProfile = provider.userProfile;
    if (userProfile == null) return const SizedBox.shrink();

    return CustomCard(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 用户信息
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userProfile.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 统计信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '查询次数',
                  userProfile.stats.queryCount.toString(),
                ),
                _buildStatItem(
                  '收藏记录',
                  userProfile.stats.bookmarkCount.toString(),
                ),
                _buildStatItem(
                  '使用天数',
                  userProfile.stats.usageDays.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingSection(SettingSection section, SettingsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            section.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CustomCard(
          margin: const EdgeInsets.only(bottom: 24),
          padding: EdgeInsets.zero,
          child: Column(
            children: section.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == section.items.length - 1;
              
              return _buildSettingItem(item, provider, !isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(SettingItem item, SettingsProvider provider, bool showDivider) {
    return InkWell(
      onTap: () => _handleSettingItemTap(item, provider),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildSettingIcon(item.iconName, item.iconColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _buildSettingAction(item, provider),
              ],
            ),
            if (showDivider) ...[
              const SizedBox(height: 16),
              Divider(
                height: 1,
                color: Colors.grey.shade100,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingIcon(String iconName, String colorName) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    // 图标映射
    switch (iconName) {
      case 'palette':
        iconData = Icons.palette;
        break;
      case 'font_download':
        iconData = Icons.font_download;
        break;
      case 'language':
        iconData = Icons.language;
        break;
      case 'save':
        iconData = Icons.save;
        break;
      case 'notifications':
        iconData = Icons.notifications;
        break;
      case 'cloud_sync':
        iconData = Icons.cloud_sync;
        break;
      case 'delete_sweep':
        iconData = Icons.delete_sweep;
        break;
      case 'feedback':
        iconData = Icons.feedback;
        break;
      case 'info':
        iconData = Icons.info;
        break;
      case 'security':
        iconData = Icons.security;
        break;
      default:
        iconData = Icons.settings;
    }

    // 颜色映射
    switch (colorName) {
      case 'blue':
        backgroundColor = Colors.blue.shade100;
        iconColor = Colors.blue.shade600;
        break;
      case 'green':
        backgroundColor = Colors.green.shade100;
        iconColor = Colors.green.shade600;
        break;
      case 'purple':
        backgroundColor = Colors.purple.shade100;
        iconColor = Colors.purple.shade600;
        break;
      case 'orange':
        backgroundColor = Colors.orange.shade100;
        iconColor = Colors.orange.shade600;
        break;
      case 'red':
        backgroundColor = Colors.red.shade100;
        iconColor = Colors.red.shade600;
        break;
      case 'teal':
        backgroundColor = Colors.teal.shade100;
        iconColor = Colors.teal.shade600;
        break;
      case 'yellow':
        backgroundColor = Colors.yellow.shade100;
        iconColor = Colors.yellow.shade600;
        break;
      case 'indigo':
        backgroundColor = Colors.indigo.shade100;
        iconColor = Colors.indigo.shade600;
        break;
      case 'pink':
        backgroundColor = Colors.pink.shade100;
        iconColor = Colors.pink.shade600;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        iconColor = Colors.grey.shade600;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildSettingAction(SettingItem item, SettingsProvider provider) {
    switch (item.type) {
      case SettingItemType.toggle:
        final isOn = provider.getToggleValue(item.title);
        return _buildToggleSwitch(isOn);
      
      case SettingItemType.navigation:
        return Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
        );
      
      case SettingItemType.action:
        return const SizedBox.shrink();
    }
  }

  Widget _buildToggleSwitch(bool isOn) {
    return Container(
      width: 48,
      height: 24,
      decoration: BoxDecoration(
        color: isOn ? Colors.blue.shade500 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: isOn ? 26 : 2,
            top: 2,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            '${AppInfo.name} v${AppInfo.version}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppInfo.copyright,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSettingItemTap(SettingItem item, SettingsProvider provider) {
    switch (item.type) {
      case SettingItemType.toggle:
        provider.handleSettingTap(item);
        break;
        
      case SettingItemType.navigation:
        _handleNavigationItem(item);
        break;
        
      case SettingItemType.action:
        _handleActionItem(item, provider);
        break;
    }
  }

  void _handleNavigationItem(SettingItem item) {
    switch (item.title) {
      case '字体大小':
        // 显示字体大小选择器
        break;
      case '语言':
        // 显示语言选择器
        break;
      case '意见反馈':
        // 打开反馈页面
        break;
      case '关于我们':
        // 显示关于页面
        break;
      case '隐私政策':
        // 显示隐私政策
        break;
    }
  }

  void _handleActionItem(SettingItem item, SettingsProvider provider) {
    switch (item.title) {
      case '清除缓存':
        _showClearCacheDialog(provider);
        break;
    }
  }

  void _showClearCacheDialog(SettingsProvider provider) {
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('清除缓存'),
    //     content: const Text('确定要清除应用缓存吗？'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: const Text('取消'),
    //       ),
    //       TextButton(
    //         onPressed: () async {
    //           Navigator.pop(context);
    //           await provider.clearCache();
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(content: Text('缓存已清除')),
    //           );
    //         },
    //         child: const Text('确定'),
    //       ),
    //     ],
    //   ),
    // );
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
        // 当前页面，无需操作
        break;
    }
  }
}