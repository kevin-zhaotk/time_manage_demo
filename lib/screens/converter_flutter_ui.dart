// 完全按照converter.html布局实现的Flutter页面
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/date_model.dart';
import '../providers/converter_provider.dart';

class ConverterFlutterUI extends StatelessWidget {
  const ConverterFlutterUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConverterProvider(),
      child: const _ConverterContent(),
    );
  }
}

class _ConverterContent extends StatelessWidget {
  const _ConverterContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
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
                _buildStatusBar(),
                
                // 主内容
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // 标题栏
                        _buildAppBar(context),
                        
                        // 转换模式切换卡片
                        _buildModeToggleCard(),
                        
                        // 转换结果卡片
                        _buildConversionResultCard(),
                        
                        // 快捷操作
                        _buildQuickActions(),
                        
                        const SizedBox(height: 100), // 底部导航空间
                      ],
                    ),
                  ),
                ),
                
                // 底部导航
                _buildBottomNavigation(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 状态栏
  Widget _buildStatusBar() {
    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, size: 17, color: Colors.black),
              SizedBox(width: 5),
              Icon(Icons.wifi, size: 17, color: Colors.black),
              SizedBox(width: 5),
              Icon(Icons.battery_3_bar, size: 17, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  // 标题栏
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
              '日期转换',
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

  // 转换模式切换卡片
  Widget _buildModeToggleCard() {
    return Consumer<ConverterProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              // 模式切换按钮
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildModeButton(
                      context: context,
                      icon: Icons.calendar_today,
                      text: '公历转农历',
                      isSelected: provider.currentMode == ConversionMode.solarToLunar,
                      onTap: () => provider.switchMode(ConversionMode.solarToLunar),
                    ),
                    _buildModeButton(
                      context: context,
                      icon: Icons.nights_stay,
                      text: '农历转公历',
                      isSelected: provider.currentMode == ConversionMode.lunarToSolar,
                      onTap: () => provider.switchMode(ConversionMode.lunarToSolar),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 日期选择器
              if (provider.currentMode == ConversionMode.solarToLunar)
                _buildSolarDateSelector(provider)
              else
                _buildLunarDateSelector(provider),
              
              const SizedBox(height: 24),
              
              // 转换按钮
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : () => provider.performConversion(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sync_alt, size: 18),
                            SizedBox(width: 8),
                            Text(
                              '开始转换',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 模式切换按钮
  Widget _buildModeButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? const Color(0xFF007AFF) : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF007AFF) : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 公历日期选择器
  Widget _buildSolarDateSelector(ConverterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择公历日期',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                value: '${provider.selectedSolarYear}年',
                items: DatePickerData.solarYears,
                onChanged: (value) {
                  if (value != null) {
                    final year = int.parse(value.replaceAll('年', ''));
                    provider.setSolarDate(year: year);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDropdown(
                value: '${provider.selectedSolarMonth}月',
                items: DatePickerData.solarMonths,
                onChanged: (value) {
                  if (value != null) {
                    final month = DatePickerData.solarMonths.indexOf(value) + 1;
                    provider.setSolarDate(month: month);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDropdown(
                value: '${provider.selectedSolarDay}日',
                items: DatePickerData.getSolarDays(
                  provider.selectedSolarMonth,
                  provider.selectedSolarYear,
                ),
                onChanged: (value) {
                  if (value != null) {
                    final day = int.parse(value.replaceAll('日', ''));
                    provider.setSolarDate(day: day);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 农历日期选择器
  Widget _buildLunarDateSelector(ConverterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择农历日期',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                value: provider.selectedLunarYear,
                items: DatePickerData.lunarYears,
                onChanged: (value) {
                  if (value != null) {
                    provider.setLunarDate(year: value);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDropdown(
                value: provider.selectedLunarMonth,
                items: DatePickerData.lunarMonths,
                onChanged: (value) {
                  if (value != null) {
                    provider.setLunarDate(month: value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          value: provider.selectedLunarDay,
          items: DatePickerData.lunarDays,
          onChanged: (value) {
            if (value != null) {
              provider.setLunarDate(day: value);
            }
          },
        ),
      ],
    );
  }

  // 下拉选择器
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey.shade600,
          ),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  // 转换结果卡片
  Widget _buildConversionResultCard() {
    return Consumer<ConverterProvider>(
      builder: (context, provider, child) {
        if (provider.errorMessage != null) {
          return _buildErrorCard(provider);
        }

        if (provider.conversionResult == null) {
          return const SizedBox.shrink();
        }

        final result = provider.conversionResult!;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    '转换结果',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.check_circle, color: Colors.green.shade500),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 公历结果
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '公历日期',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.solarDate.formattedDate,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.solarDate.weekday,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 箭头指示
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade500,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 农历结果
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  border: Border.all(color: Colors.purple.shade100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '农历日期',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.lunarDate.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.lunarDate.year,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 详细信息
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade100),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailRow('节气', result.solarTerm),
                        ),
                        Expanded(
                          child: _buildDetailRow('星宿', result.constellation),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailRow('五行', result.wuxing),
                        ),
                        Expanded(
                          child: _buildDetailRow('冲煞', result.chongsha),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 错误卡片
  Widget _buildErrorCard(ConverterProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '转换失败',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(Icons.error, color: Colors.red.shade500),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            provider.errorMessage!,
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: provider.clearError,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  // 详细信息行
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label：',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // 快捷操作
  Widget _buildQuickActions() {
    return Consumer<ConverterProvider>(
      builder: (context, provider, child) {
        if (provider.conversionResult == null) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.bookmark,
                label: '收藏',
                color: Colors.blue.shade500,
                onTap: () {
                  provider.bookmarkResult();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已收藏')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.share,
                label: '分享',
                color: Colors.green.shade500,
                onTap: () {
                  provider.shareResult();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('分享功能开发中')),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // 操作按钮
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 底部导航
  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: 83,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home,
              label: '主页',
              isActive: false,
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            _buildNavItem(
              icon: Icons.swap_horiz,
              label: '转换',
              isActive: true,
              onTap: () {},
            ),
            _buildNavItem(
              icon: Icons.history,
              label: '记录',
              isActive: false,
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/history');
              },
            ),
            _buildNavItem(
              icon: Icons.settings,
              label: '设置',
              isActive: false,
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  // 导航项
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? const Color(0xFF007AFF) : Colors.grey.shade500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive ? const Color(0xFF007AFF) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}