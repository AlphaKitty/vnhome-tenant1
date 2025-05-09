import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/shared/widgets/app_bar_widget.dart';
import '../viewmodels/house_provider.dart';

/// 房源详情页面
class HouseDetailScreen extends ConsumerWidget {
  final String houseId;

  const HouseDetailScreen({super.key, required this.houseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final house = ref.watch(houseDetailProvider(houseId));

    if (house == null) {
      return Scaffold(
        appBar: const AppBarWidget(title: '房源详情', showBackButton: true),
        body: const Center(child: Text('未找到该房源信息')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部图片和返回按钮
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  house.imageUrls.isNotEmpty
                      ? Image.network(
                        house.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                ),
                              ),
                            ),
                      )
                      : Container(
                        color: Colors.grey.shade300,
                        child: const Center(child: Icon(Icons.home, size: 50)),
                      ),
            ),
            leading: Padding(
              padding: EdgeInsets.all(DesignTokens.spacingXSmall),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(DesignTokens.spacingXSmall),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  child: IconButton(
                    icon: Icon(
                      house.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: house.isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      ref
                          .read(houseListProvider.notifier)
                          .toggleFavorite(house.id);
                    },
                  ),
                ),
              ),
            ],
          ),

          // 房源信息
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(DesignTokens.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 价格
                  Text(
                    '¥${house.price.toStringAsFixed(0)}/月',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: DesignTokens.spacingSmall),

                  // 标题
                  Text(
                    house.title,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: DesignTokens.spacingSmall),

                  // 位置
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: DesignTokens.spacingXXSmall),
                      Text(
                        house.location,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSmall,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: DesignTokens.spacingMedium),

                  // 房源特征
                  _buildFeatures(context, house),

                  SizedBox(height: DesignTokens.spacingMedium),

                  // 房源标签
                  if (house.tags.isNotEmpty) _buildTags(context, house.tags),

                  SizedBox(height: DesignTokens.spacingMedium),

                  // 描述标题
                  Text(
                    '房源描述',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: DesignTokens.spacingSmall),

                  // 描述内容
                  Text(
                    house.description ?? '暂无描述',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeSmall,
                      height: DesignTokens.lineHeightNormal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 底部按钮
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            // 联系房东按钮
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text('联系房东'),
                onPressed: () {
                  // TODO: 实现联系房东功能
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('联系房东功能开发中')));
                },
              ),
            ),

            SizedBox(width: DesignTokens.spacingMedium),

            // 预约看房按钮
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('预约看房'),
                onPressed: () {
                  // TODO: 实现预约看房功能
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('预约看房功能开发中')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建房源特征部分
  Widget _buildFeatures(BuildContext context, dynamic house) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingMedium),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFeatureItem(context, '户型', house.roomType),
          _buildFeatureItem(
            context,
            '面积',
            '${house.area.toStringAsFixed(0)}m²',
          ),
          _buildFeatureItem(context, '朝向', house.direction),
          _buildFeatureItem(context, '楼层', house.floor),
        ],
      ),
    );
  }

  /// 构建单个特征项
  Widget _buildFeatureItem(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: DesignTokens.spacingXXSmall),
        Text(
          title,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeXSmall,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// 构建标签列表
  Widget _buildTags(BuildContext context, List<String> tags) {
    return Wrap(
      spacing: DesignTokens.spacingSmall,
      runSpacing: DesignTokens.spacingSmall,
      children: tags.map((tag) => _buildTagItem(context, tag)).toList(),
    );
  }

  /// 构建单个标签
  Widget _buildTagItem(BuildContext context, String tag) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSmall,
        vertical: DesignTokens.spacingXXSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeXSmall,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
