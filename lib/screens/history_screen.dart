// 历史记录页面
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/history_model.dart';
import '../providers/history_provider.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/bottom_navigation.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryProvider()..initializeHistoryData(),
      child: const _HistoryScreenContent(),
    );
  }
}

class _HistoryScreenContent extends StatefulWidget {
  const _HistoryScreenContent({Key? key}) : super(key: key);

  @override
  State<_HistoryScreenContent> createState() => _HistoryScreenContentState();
}

class _HistoryScreenContentState extends State<_HistoryScreenContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                child: Consumer<HistoryProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.errorMessage != null) {
                      return _buildErrorView(provider);
                    }

                    return Column(
                      children: [
                        // 标题栏
                        _buildAppBar(provider),
                        
                        // 搜索栏
                        _buildSearchBar(provider),
                        
                        // 主内容
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: provider.refresh,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: provider.isSearching
                                  ? _buildSearchResults(provider)
                                  : _buildMainContent(provider),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 2,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildErrorView(HistoryProvider provider) {
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
                provider.initializeHistoryData();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(HistoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              '查询记录',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showClearDialog(provider),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red.shade500,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(HistoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: provider.searchHistory,
          decoration: InputDecoration(
            hintText: '搜索历史记录...',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade400,
            ),
            suffixIcon: provider.isSearching
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      provider.clearSearch();
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.grey.shade400,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(HistoryProvider provider) {
    if (provider.filteredItems.isEmpty) {
      return _buildEmptySearch();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            '搜索结果 (${provider.filteredItems.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...provider.filteredItems.map((item) => _buildHistoryItemCard(item, provider)),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              '没有找到相关记录',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(HistoryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 收藏夹
        if (provider.bookmarks.isNotEmpty) _buildBookmarksSection(provider),
        
        // 历史记录分组
        ...provider.historyGroups.map((group) => _buildHistoryGroup(group, provider)),
        
        // 加载更多按钮
        if (provider.totalHistoryCount > 0) _buildLoadMoreButton(),
        
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildBookmarksSection(HistoryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              const Text(
                '收藏夹',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(Icons.star, color: Colors.yellow.shade600),
            ],
          ),
        ),
        ...provider.bookmarks.map((bookmark) => _buildBookmarkCard(bookmark, provider)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBookmarkCard(BookmarkItem bookmark, HistoryProvider provider) {
    Color backgroundColor;
    Color iconColor;
    IconData iconData;

    switch (bookmark.color) {
      case 'yellow':
        backgroundColor = Colors.yellow.shade100;
        iconColor = Colors.yellow.shade600;
        break;
      case 'red':
        backgroundColor = Colors.red.shade100;
        iconColor = Colors.red.shade600;
        break;
      default:
        backgroundColor = Colors.blue.shade100;
        iconColor = Colors.blue.shade600;
    }

    switch (bookmark.iconType) {
      case 'birthday_cake':
        iconData = Icons.cake;
        break;
      case 'heart':
        iconData = Icons.favorite;
        break;
      default:
        iconData = Icons.bookmark;
    }

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        // 导航到转换页面并预填数据
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconData,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookmark.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bookmark.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showBookmarkOptions(bookmark, provider),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.chevron_right,
                color: Colors.blue.shade500,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryGroup(HistoryGroup group, HistoryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Text(
                group.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                group.subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        ...group.items.map((item) => _buildHistoryItemCard(item, provider)),
      ],
    );
  }

  Widget _buildHistoryItemCard(HistoryItem item, HistoryProvider provider) {
    Color backgroundColor;
    Color iconColor;
    IconData iconData;

    switch (item.iconColor) {
      case 'blue':
        backgroundColor = Colors.blue.shade100;
        iconColor = Colors.blue.shade600;
        break;
      case 'purple':
        backgroundColor = Colors.purple.shade100;
        iconColor = Colors.purple.shade600;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        iconColor = Colors.grey.shade600;
    }

    switch (item.iconType) {
      case 'calendar':
        iconData = Icons.calendar_today;
        break;
      case 'moon':
        iconData = Icons.nights_stay;
        break;
      default:
        iconData = Icons.history;
    }

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
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
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.primaryText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.secondaryText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.formattedTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => provider.toggleBookmark(item),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: item.isBookmarked 
                        ? Colors.yellow.shade50 
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    item.isBookmarked ? Icons.star : Icons.star_border,
                    color: item.isBookmarked 
                        ? Colors.yellow.shade600 
                        : Colors.grey.shade400,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => provider.reconvert(item),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.blue.shade500,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: TextButton.icon(
          onPressed: () {
            // 加载更多历史记录
          },
          icon: const Icon(Icons.keyboard_arrow_down),
          label: const Text('加载更多记录'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue.shade600,
          ),
        ),
      ),
    );
  }

  void _showClearDialog(HistoryProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空历史记录'),
        content: const Text('确定要清空所有历史记录吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('历史记录已清空')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showBookmarkOptions(BookmarkItem bookmark, HistoryProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('编辑收藏'),
              onTap: () {
                Navigator.pop(context);
                // 编辑收藏功能
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除收藏', style: TextStyle(color: Colors.red)),
              onTap: () {
                provider.deleteBookmark(bookmark);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已删除收藏')),
                );
              },
            ),
          ],
        ),
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
        // 当前页面，无需操作
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/settings');
        break;
    }
  }
}