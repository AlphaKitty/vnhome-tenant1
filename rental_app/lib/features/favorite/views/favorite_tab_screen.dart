import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/shared/widgets/house_card_widget.dart';
import '../models/favorite_model.dart';
import '../viewmodels/favorite_provider.dart';

/// 收藏标签页面
class FavoriteTabScreen extends ConsumerStatefulWidget {
  const FavoriteTabScreen({super.key});

  @override
  ConsumerState<FavoriteTabScreen> createState() => _FavoriteTabScreenState();
}

class _FavoriteTabScreenState extends ConsumerState<FavoriteTabScreen> {
  @override
  void initState() {
    super.initState();
    // 加载收藏和浏览记录
    Future.microtask(() => ref.read(favoriteProvider.notifier).loadRecords());
  }

  @override
  Widget build(BuildContext context) {
    final favoriteState = ref.watch(favoriteProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // 显示筛选选项
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('筛选功能开发中')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 标签按钮区域
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingMedium),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => ref
                            .read(favoriteProvider.notifier)
                            .selectTab(FavoriteTabOption.favorite),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          favoriteState.selectedTab ==
                                  FavoriteTabOption.favorite
                              ? theme.primaryColor
                              : theme.cardColor,
                      foregroundColor:
                          favoriteState.selectedTab ==
                                  FavoriteTabOption.favorite
                              ? Colors.white
                              : theme.textTheme.bodyLarge?.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusSmall,
                        ),
                        side: BorderSide(
                          color:
                              favoriteState.selectedTab ==
                                      FavoriteTabOption.favorite
                                  ? Colors.transparent
                                  : theme.dividerColor,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: DesignTokens.spacingSmall,
                      ),
                    ),
                    child: const Text('全部收藏'),
                  ),
                ),
                SizedBox(width: DesignTokens.spacingMedium),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => ref
                            .read(favoriteProvider.notifier)
                            .selectTab(FavoriteTabOption.history),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          favoriteState.selectedTab == FavoriteTabOption.history
                              ? theme.primaryColor
                              : theme.cardColor,
                      foregroundColor:
                          favoriteState.selectedTab == FavoriteTabOption.history
                              ? Colors.white
                              : theme.textTheme.bodyLarge?.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusSmall,
                        ),
                        side: BorderSide(
                          color:
                              favoriteState.selectedTab ==
                                      FavoriteTabOption.history
                                  ? Colors.transparent
                                  : theme.dividerColor,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: DesignTokens.spacingSmall,
                      ),
                    ),
                    child: const Text('最近浏览'),
                  ),
                ),
              ],
            ),
          ),

          // 列表区域
          Expanded(
            child:
                favoriteState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : favoriteState.error != null
                    ? _buildErrorView(favoriteState.error!)
                    : favoriteState.currentRecords.isEmpty
                    ? _buildEmptyView(
                      favoriteState.selectedTab == FavoriteTabOption.favorite
                          ? '暂无收藏房源'
                          : '暂无浏览记录',
                    )
                    : _buildRecordsList(
                      favoriteState.currentRecords,
                      favoriteState.selectedTab,
                    ),
          ),
        ],
      ),
    );
  }

  /// 构建记录列表
  Widget _buildRecordsList(
    List<FavoriteRecordModel> records,
    FavoriteTabOption currentTab,
  ) {
    // 按时间排序记录
    final sortedRecords = List<FavoriteRecordModel>.from(records)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingMedium),
      itemCount:
          currentTab == FavoriteTabOption.history
              ? sortedRecords.length + 1
              : sortedRecords.length,
      itemBuilder: (context, index) {
        // 如果是浏览记录且是最后一个位置，显示清除按钮
        if (currentTab == FavoriteTabOption.history &&
            index == sortedRecords.length) {
          return Padding(
            padding: EdgeInsets.all(DesignTokens.spacingMedium),
            child: TextButton(
              onPressed:
                  () => ref.read(favoriteProvider.notifier).clearHistory(),
              child: const Text('清除浏览记录'),
            ),
          );
        }

        final record = sortedRecords[index];
        return _buildRecordItem(record, currentTab);
      },
    );
  }

  /// 构建单个记录项
  Widget _buildRecordItem(
    FavoriteRecordModel record,
    FavoriteTabOption currentTab,
  ) {
    final house = record.house;

    // 格式化日期时间
    final now = DateTime.now();
    final difference = now.difference(record.timestamp);
    String formattedTime;

    if (difference.inDays > 0) {
      formattedTime = '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      formattedTime = '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      formattedTime = '${difference.inMinutes}分钟前';
    } else {
      formattedTime = '刚刚';
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMedium,
        vertical: DesignTokens.spacingSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 时间标签
          Padding(
            padding: EdgeInsets.only(
              left: DesignTokens.spacingSmall,
              bottom: DesignTokens.spacingXSmall,
            ),
            child: Text(
              formattedTime,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXSmall,
                color: Colors.grey[600],
              ),
            ),
          ),
          // 房源卡片
          HouseCardWidget(
            title: house.title,
            location: house.location,
            price: house.price,
            roomType: house.roomType,
            area: house.area,
            floor: house.floor,
            onTap: () {
              AppRouter.navigateTo(
                context,
                AppRouter.houseDetail,
                arguments: house.id,
              );
            },
            actions: [
              _buildActionButton(
                context: context,
                icon:
                    currentTab == FavoriteTabOption.favorite
                        ? Icons.delete_outline
                        : Icons.favorite_border,
                title: currentTab == FavoriteTabOption.favorite ? '移除' : '收藏',
                onPressed: () => _handleActionPressed(record, currentTab),
              ),
              _buildActionButton(
                context: context,
                icon: Icons.home_outlined,
                title: '预约看房',
                primary: true,
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('预约看房功能开发中')));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    bool primary = false,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 18,
          color: primary ? Colors.white : theme.primaryColor,
        ),
        label: Text(
          title,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSmall,
            color: primary ? Colors.white : theme.primaryColor,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: primary ? theme.primaryColor : Colors.transparent,
          padding: EdgeInsets.symmetric(
            vertical: DesignTokens.spacingXSmall,
            horizontal: DesignTokens.spacingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
            side: BorderSide(
              color: primary ? Colors.transparent : theme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  /// 处理操作按钮点击
  void _handleActionPressed(
    FavoriteRecordModel record,
    FavoriteTabOption currentTab,
  ) {
    if (currentTab == FavoriteTabOption.favorite) {
      // 移除收藏
      ref.read(favoriteProvider.notifier).removeFavorite(record.id);
    } else {
      // 收藏浏览记录
      ref.read(favoriteProvider.notifier).addFavorite(record.house);
    }
  }

  /// 构建空记录视图
  Widget _buildEmptyView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          SizedBox(height: DesignTokens.spacingMedium),
          Text(
            message,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMedium,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建错误视图
  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          SizedBox(height: DesignTokens.spacingMedium),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.spacingSmall),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSmall,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: DesignTokens.spacingMedium),
          ElevatedButton(
            onPressed: () => ref.read(favoriteProvider.notifier).loadRecords(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}
