// 日期转换器主页面
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/date_model.dart';
import '../providers/converter_provider.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/bottom_navigation.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConverterProvider(),
      child: const _ConverterScreenContent(),
    );
  }
}

class _ConverterScreenContent extends StatelessWidget {
  const _ConverterScreenContent({Key? key}) : super(key: key);

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // 标题栏
                      _buildAppBar(context),
                      
                      // 转换模式切换
                      _buildModeToggle(),
                      
                      // 日期选择区域
                      _buildDateSelector(),
                      
                      // 转换按钮
                      _buildConvertButton(),
                      
                      // 转换结果
                      _buildConversionResult(),
                      
                      // 快捷操作
                      _buildQuickActions(),
                      
                      const SizedBox(height: 100), // 底部导航空间
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 1,
        onTap: (index) {
          // 处理导航
          _handleNavigation(context, index);
        },
      ),
    );
  }

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

  Widget _buildModeToggle() {
    return Consumer<ConverterProvider>(
      builder: (context, provider, child) {
        return CustomCard(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    ModeToggleButton(
                      text: '公历转农历',
                      icon: Icons.calendar_today,
                      isSelected: provider.currentMode == ConversionMode.solarToLunar,
                      onTap: () => provider.switchMode(ConversionMode.solarToLunar),
                    ),
                    ModeToggleButton(
                      text: '农历转公历',
                      icon: Icons.nights_stay,
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateSelector() {
    return const SizedBox.shrink(); // 已在 _buildModeToggle 中包含
  }

  Widget _buildSolarDateSelector(ConverterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择公历日期',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CustomDropdown(
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
              child: CustomDropdown(
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
              child: CustomDropdown(
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

  Widget _buildLunarDateSelector(ConverterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择农历日期',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CustomDropdown(
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
              child: CustomDropdown(
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
        CustomDropdown(
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

  Widget _buildConvertButton() {
    return Consumer<ConverterProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : () => provider.performConversion(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
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
        );
      },
    );
  }

  Widget _buildConversionResult() {
    return Consumer<ConverterProvider>(
      builder: (context, provider, child) {
        if (provider.errorMessage != null) {
          return CustomCard(
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

        if (provider.conversionResult == null) {
          return const SizedBox.shrink();
        }

        final result = provider.conversionResult!;
        
        return CustomCard(
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
              ResultCard(
                title: '公历日期',
                mainText: result.solarDate.formattedDate,
                subText: result.solarDate.weekday,
                backgroundColor: Colors.blue.shade50,
                textColor: Colors.blue.shade600,
                titleColor: Colors.blue.shade900,
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
              ResultCard(
                title: '农历日期',
                mainText: result.lunarDate.toString(),
                subText: result.lunarDate.year,
                backgroundColor: Colors.purple.shade50,
                textColor: Colors.purple.shade600,
                titleColor: Colors.purple.shade900,
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
                          child: DetailRow(
                            label: '节气',
                            value: result.solarTerm,
                          ),
                        ),
                        Expanded(
                          child: DetailRow(
                            label: '星宿',
                            value: result.constellation,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DetailRow(
                            label: '五行',
                            value: result.wuxing,
                          ),
                        ),
                        Expanded(
                          child: DetailRow(
                            label: '冲煞',
                            value: result.chongsha,
                          ),
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

  Widget _buildQuickActions() {
    return Consumer<ConverterProvider>(
      builder: (context, provider, child) {
        if (provider.conversionResult == null) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            ActionButton(
              icon: Icons.bookmark,
              label: '收藏',
              iconColor: Colors.blue.shade500,
              onTap: () {
                provider.bookmarkResult();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已收藏')),
                );
              },
            ),
            const SizedBox(width: 12),
            ActionButton(
              icon: Icons.share,
              label: '分享',
              iconColor: Colors.green.shade500,
              onTap: () {
                provider.shareResult();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('分享功能开发中')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // 导航到主页
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        // 当前页面，无需操作
        break;
      case 2:
        // 导航到历史记录
        Navigator.of(context).pushReplacementNamed('/history');
        break;
      case 3:
        // 导航到设置
        Navigator.of(context).pushReplacementNamed('/settings');
        break;
    }
  }
}