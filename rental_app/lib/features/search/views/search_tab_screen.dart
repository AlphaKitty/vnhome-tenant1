import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/features/house/models/house_model.dart';
import 'package:rental_app/shared/widgets/house_card_widget.dart';
import '../models/search_filter_model.dart';
import '../viewmodels/search_provider.dart';
import 'filter_button_widget.dart';
import 'tag_chip_widget.dart';

/// 搜索页面标签视图
class SearchTabScreen extends ConsumerStatefulWidget {
  final String? initialKeyword;

  const SearchTabScreen({super.key, this.initialKeyword});

  @override
  ConsumerState<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends ConsumerState<SearchTabScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilterPanel = false;

  @override
  void initState() {
    super.initState();

    // 设置初始搜索关键词
    if (widget.initialKeyword != null && widget.initialKeyword!.isNotEmpty) {
      _searchController.text = widget.initialKeyword!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchProvider.notifier).updateKeyword(widget.initialKeyword!);
        ref.read(searchProvider.notifier).search();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final filter = searchState.filter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              // TODO: 实现地图视图
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('地图功能开发中')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingMedium),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索地区、小区名',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(searchProvider.notifier).updateKeyword('');
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    DesignTokens.radiusMedium,
                  ),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              onSubmitted: (value) {
                ref.read(searchProvider.notifier).updateKeyword(value);
                ref.read(searchProvider.notifier).search();
              },
            ),
          ),

          // 筛选按钮行
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMedium,
              vertical: DesignTokens.spacingSmall,
            ),
            child: Row(
              children: [
                FilterButtonWidget(
                  title:
                      filter.area != null && filter.area!.isNotEmpty
                          ? filter.area!
                          : '区域',
                  isSelected: filter.area != null && filter.area!.isNotEmpty,
                  onTap: () {
                    _toggleFilterPanel();
                    _showAreaFilterDialog(context);
                  },
                ),
                SizedBox(width: DesignTokens.spacingSmall),
                FilterButtonWidget(
                  title:
                      filter.priceRange != null
                          ? filter.priceRange.toString()
                          : '价格',
                  isSelected: filter.priceRange != null,
                  onTap: () {
                    _toggleFilterPanel();
                    _showPriceFilterDialog(context);
                  },
                ),
                SizedBox(width: DesignTokens.spacingSmall),
                FilterButtonWidget(
                  title:
                      filter.houseType != null && filter.houseType!.isNotEmpty
                          ? filter.houseType!
                          : '户型',
                  isSelected:
                      filter.houseType != null && filter.houseType!.isNotEmpty,
                  onTap: () {
                    _toggleFilterPanel();
                    _showHouseTypeFilterDialog(context);
                  },
                ),
                SizedBox(width: DesignTokens.spacingSmall),
                FilterButtonWidget(
                  title: '更多',
                  isSelected: _showFilterPanel,
                  onTap: _toggleFilterPanel,
                ),
              ],
            ),
          ),

          // 热门标签行（只在展开筛选面板时显示）
          if (_showFilterPanel) _buildFilterPanel(context, filter),

          // 搜索结果列表
          Expanded(
            child:
                searchState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : searchState.error != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '搜索失败',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingSmall),
                          Text(
                            searchState.error!,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeSmall,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingMedium),
                          ElevatedButton(
                            onPressed:
                                () =>
                                    ref.read(searchProvider.notifier).search(),
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    )
                    : searchState.searchResults.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: DesignTokens.spacingMedium),
                          Text(
                            '暂无搜索结果',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeMedium,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingSmall),
                          Text(
                            '请尝试调整搜索条件',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeSmall,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: DesignTokens.spacingMedium,
                      ),
                      itemCount: searchState.searchResults.length,
                      itemBuilder: (context, index) {
                        final house = searchState.searchResults[index];
                        return _buildHouseCard(context, house);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  /// 切换筛选面板显示状态
  void _toggleFilterPanel() {
    setState(() {
      _showFilterPanel = !_showFilterPanel;
    });
  }

  /// 构建筛选面板
  Widget _buildFilterPanel(BuildContext context, SearchFilterModel filter) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            '热门推荐',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.spacingSmall),

          // 热门标签
          Wrap(
            spacing: DesignTokens.spacingSmall,
            runSpacing: DesignTokens.spacingSmall,
            children: [
              TagChipWidget(
                label: '近地铁',
                isSelected: filter.tags.contains('近地铁'),
                onTap: () => _toggleTagSelection('近地铁'),
              ),
              TagChipWidget(
                label: '拎包入住',
                isSelected: filter.tags.contains('拎包入住'),
                onTap: () => _toggleTagSelection('拎包入住'),
              ),
              TagChipWidget(
                label: '精装修',
                isSelected: filter.tags.contains('精装修'),
                onTap: () => _toggleTagSelection('精装修'),
              ),
              TagChipWidget(
                label: '南北通透',
                isSelected: filter.tags.contains('南北通透'),
                onTap: () => _toggleTagSelection('南北通透'),
              ),
              TagChipWidget(
                label: '合租',
                isSelected: filter.tags.contains('合租'),
                onTap: () => _toggleTagSelection('合租'),
              ),
              TagChipWidget(
                label: '朝南',
                isSelected: filter.tags.contains('朝南'),
                onTap: () => _toggleTagSelection('朝南'),
              ),
            ],
          ),

          SizedBox(height: DesignTokens.spacingLarge),

          // 清除筛选按钮
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('清除筛选条件'),
              onPressed: () {
                ref.read(searchProvider.notifier).clearFilters();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 切换标签选择状态
  void _toggleTagSelection(String tag) {
    final tags = ref.read(searchProvider).filter.tags;
    if (tags.contains(tag)) {
      ref.read(searchProvider.notifier).removeTag(tag);
    } else {
      ref.read(searchProvider.notifier).addTag(tag);
    }
  }

  /// 显示区域筛选对话框
  void _showAreaFilterDialog(BuildContext context) {
    final areas = ['朝阳区', '海淀区', '东城区', '西城区', '丰台区', '大兴区', '通州区', '昌平区'];

    showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('选择区域'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: areas.length,
                itemBuilder: (context, index) {
                  final area = areas[index];
                  return ListTile(
                    title: Text(area),
                    onTap: () {
                      Navigator.of(context).pop(area);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
            ],
          ),
    ).then((value) {
      if (value != null) {
        ref.read(searchProvider.notifier).updateArea(value);
      }
    });
  }

  /// 显示价格筛选对话框
  void _showPriceFilterDialog(BuildContext context) {
    final priceRanges = [
      const PriceRange(max: 3000),
      const PriceRange(min: 3000, max: 5000),
      const PriceRange(min: 5000, max: 8000),
      const PriceRange(min: 8000, max: 12000),
      const PriceRange(min: 12000),
    ];

    showDialog<PriceRange>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('选择价格范围'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: priceRanges.length,
                itemBuilder: (context, index) {
                  final price = priceRanges[index];
                  return ListTile(
                    title: Text(price.toString()),
                    onTap: () {
                      Navigator.of(context).pop(price);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
            ],
          ),
    ).then((value) {
      if (value != null) {
        ref.read(searchProvider.notifier).updatePriceRange(value);
      }
    });
  }

  /// 显示户型筛选对话框
  void _showHouseTypeFilterDialog(BuildContext context) {
    final houseTypes = ['1室1厅', '2室1厅', '2室2厅', '3室1厅', '3室2厅', '4室2厅'];

    showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('选择户型'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: houseTypes.length,
                itemBuilder: (context, index) {
                  final type = houseTypes[index];
                  return ListTile(
                    title: Text(type),
                    onTap: () {
                      Navigator.of(context).pop(type);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
            ],
          ),
    ).then((value) {
      if (value != null) {
        ref.read(searchProvider.notifier).updateHouseType(value);
      }
    });
  }

  /// 构建房源卡片
  Widget _buildHouseCard(BuildContext context, HouseModel house) {
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
