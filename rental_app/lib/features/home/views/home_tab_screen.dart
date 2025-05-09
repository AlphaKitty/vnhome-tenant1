import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/features/house/models/house_model.dart';
import 'package:rental_app/features/house/viewmodels/house_provider.dart';
import 'package:rental_app/shared/widgets/house_card_widget.dart';

/// 首页标签视图
class HomeTabScreen extends ConsumerWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final houseState = ref.watch(houseListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [const Text('城市: 北京'), const Icon(Icons.arrow_drop_down)],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: 实现通知功能
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          Container(
            margin: EdgeInsets.all(DesignTokens.spacingMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索地区、小区名',
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: DesignTokens.spacingSmall,
                ),
              ),
              onSubmitted: (value) {
                // TODO: 实现搜索功能
                AppRouter.navigateTo(
                  context,
                  AppRouter.search,
                  arguments: value,
                );
              },
            ),
          ),

          // 房源列表
          Expanded(
            child:
                houseState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : houseState.error != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '加载失败',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingSmall),
                          Text(
                            houseState.error!,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeSmall,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingMedium),
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(houseListProvider.notifier)
                                  .fetchHouses();
                            },
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: () async {
                        return ref
                            .read(houseListProvider.notifier)
                            .fetchHouses();
                      },
                      child:
                          houseState.houses.isEmpty
                              ? const Center(child: Text('暂无房源数据'))
                              : ListView.builder(
                                padding: EdgeInsets.only(
                                  bottom: DesignTokens.spacingMedium,
                                ),
                                itemCount: houseState.houses.length,
                                itemBuilder: (context, index) {
                                  final house = houseState.houses[index];
                                  return _buildHouseCard(context, house, ref);
                                },
                              ),
                    ),
          ),
        ],
      ),
    );
  }

  /// 构建房源卡片
  Widget _buildHouseCard(
    BuildContext context,
    HouseModel house,
    WidgetRef ref,
  ) {
    return HouseCardWidget(
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
    );
  }
}
