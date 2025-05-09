import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';

/// 房源卡片组件
class HouseCardWidget extends StatelessWidget {
  final String title;
  final String location;
  final double price;
  final String? imageUrl;
  final String roomType;
  final double area;
  final String floor;
  final VoidCallback onTap;

  const HouseCardWidget({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    this.imageUrl,
    required this.roomType,
    required this.area,
    required this.floor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMedium,
        vertical: DesignTokens.spacingSmall,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 房源图片
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: DesignTokens.circularRadiusMedium,
                    topRight: DesignTokens.circularRadiusMedium,
                  ),
                  child:
                      imageUrl != null && imageUrl!.isNotEmpty
                          ? Image.network(
                            imageUrl!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  height: 150,
                                  color: Colors.grey.shade300,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                  ),
                                ),
                          )
                          : Container(
                            height: 150,
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Icon(Icons.home, size: 40),
                          ),
                ),
                // 价格标签
                Positioned(
                  right: DesignTokens.spacingSmall,
                  bottom: DesignTokens.spacingSmall,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingSmall,
                      vertical: DesignTokens.spacingXSmall,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSmall,
                      ),
                    ),
                    child: Text(
                      '¥${price.toStringAsFixed(0)}/月',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: DesignTokens.fontSizeSmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // 房源信息
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: DesignTokens.spacingXSmall),
                  // 位置
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: DesignTokens.spacingXXSmall),
                      Expanded(
                        child: Text(
                          location,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingSmall),
                  // 特征
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFeature(context, Icons.bed, roomType),
                      _buildFeature(
                        context,
                        Icons.straighten,
                        '${area.toStringAsFixed(0)}m²',
                      ),
                      _buildFeature(context, Icons.apartment, floor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建特征项
  Widget _buildFeature(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: DesignTokens.spacingXXSmall),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
