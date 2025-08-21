// 历史记录页面状态管理
import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../models/date_model.dart';

class HistoryProvider with ChangeNotifier {
  // 收藏夹
  List<BookmarkItem> _bookmarks = [];
  List<BookmarkItem> get bookmarks => _bookmarks;

  // 历史记录分组
  List<HistoryGroup> _historyGroups = [];
  List<HistoryGroup> get historyGroups => _historyGroups;

  // 搜索相关
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  List<HistoryItem> _filteredItems = [];
  List<HistoryItem> get filteredItems => _filteredItems;
  
  bool get isSearching => _searchQuery.isNotEmpty;

  // 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 初始化历史数据
  Future<void> initializeHistoryData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadBookmarks(),
        _loadHistoryGroups(),
      ]);
    } catch (e) {
      _errorMessage = '加载历史记录失败：${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 加载收藏夹
  Future<void> _loadBookmarks() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));
    _bookmarks = DefaultBookmarks.items;
  }

  // 加载历史记录分组
  Future<void> _loadHistoryGroups() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    _historyGroups = MockHistoryData.groupedHistory;
  }

  // 搜索历史记录
  void searchHistory(String query) {
    _searchQuery = query.trim();
    
    if (_searchQuery.isEmpty) {
      _filteredItems.clear();
    } else {
      final allItems = <HistoryItem>[];
      for (final group in _historyGroups) {
        allItems.addAll(group.items);
      }
      
      _filteredItems = allItems.where((item) {
        final primaryText = item.primaryText.toLowerCase();
        final secondaryText = item.secondaryText.toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        
        return primaryText.contains(queryLower) || 
               secondaryText.contains(queryLower);
      }).toList();
    }
    
    notifyListeners();
  }

  // 切换收藏状态
  void toggleBookmark(HistoryItem item) {
    final index = _historyGroups.indexWhere((group) => 
        group.items.any((historyItem) => historyItem.id == item.id));
    
    if (index != -1) {
      final groupItems = _historyGroups[index].items;
      final itemIndex = groupItems.indexWhere((historyItem) => historyItem.id == item.id);
      
      if (itemIndex != -1) {
        // 创建新的HistoryItem with updated bookmark status
        final updatedItem = HistoryItem(
          id: item.id,
          conversionResult: item.conversionResult,
          createdAt: item.createdAt,
          conversionMode: item.conversionMode,
          isBookmarked: !item.isBookmarked,
        );
        
        groupItems[itemIndex] = updatedItem;
        
        if (updatedItem.isBookmarked) {
          // 添加到收藏夹
          _addToBookmarks(updatedItem);
        } else {
          // 从收藏夹移除
          _removeFromBookmarks(updatedItem.id);
        }
        
        notifyListeners();
      }
    }
  }

  // 添加到收藏夹
  void _addToBookmarks(HistoryItem item) {
    final bookmark = BookmarkItem(
      id: 'bookmark_${item.id}',
      title: '转换记录',
      description: '${item.primaryText} → ${item.secondaryText.split(' ·')[0]}',
      conversionResult: item.conversionResult,
      createdAt: item.createdAt,
      iconType: item.iconType,
      color: item.iconColor,
    );
    
    _bookmarks.insert(0, bookmark);
  }

  // 从收藏夹移除
  void _removeFromBookmarks(String historyItemId) {
    _bookmarks.removeWhere((bookmark) => bookmark.id == 'bookmark_$historyItemId');
  }

  // 重新转换
  void reconvert(HistoryItem item) {
    // 这里应该导航到转换页面并预填数据
    debugPrint('重新转换: ${item.primaryText}');
  }

  // 删除历史记录
  void deleteHistoryItem(HistoryItem item) {
    for (final group in _historyGroups) {
      group.items.removeWhere((historyItem) => historyItem.id == item.id);
    }
    
    // 同时从收藏夹中移除
    _removeFromBookmarks(item.id);
    
    notifyListeners();
  }

  // 清空历史记录
  void clearHistory() {
    _historyGroups.clear();
    _filteredItems.clear();
    _searchQuery = '';
    notifyListeners();
  }

  // 删除收藏项目
  void deleteBookmark(BookmarkItem bookmark) {
    _bookmarks.removeWhere((item) => item.id == bookmark.id);
    notifyListeners();
  }

  // 获取总的历史记录数量
  int get totalHistoryCount {
    return _historyGroups.fold(0, (sum, group) => sum + group.items.length);
  }

  // 获取收藏数量
  int get bookmarkCount => _bookmarks.length;

  // 刷新数据
  Future<void> refresh() async {
    await initializeHistoryData();
  }

  // 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 清除搜索
  void clearSearch() {
    _searchQuery = '';
    _filteredItems.clear();
    notifyListeners();
  }
}