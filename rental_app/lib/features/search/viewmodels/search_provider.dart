import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/features/house/models/house_model.dart';
import '../models/search_filter_model.dart';

/// 搜索状态
class SearchState {
  final SearchFilterModel filter;
  final List<HouseModel> searchResults;
  final bool isLoading;
  final String? error;

  SearchState({
    SearchFilterModel? filter,
    this.searchResults = const [],
    this.isLoading = false,
    this.error,
  }) : filter = filter ?? SearchFilterModel();

  /// 创建加载状态
  SearchState copyWithLoading() {
    return SearchState(
      filter: filter,
      searchResults: searchResults,
      isLoading: true,
      error: null,
    );
  }

  /// 创建结果状态
  SearchState copyWithResults(List<HouseModel> results) {
    return SearchState(
      filter: filter,
      searchResults: results,
      isLoading: false,
      error: null,
    );
  }

  /// 创建筛选器更新状态
  SearchState copyWithFilter(SearchFilterModel newFilter) {
    return SearchState(
      filter: newFilter,
      searchResults: searchResults,
      isLoading: false,
      error: error,
    );
  }

  /// 创建错误状态
  SearchState copyWithError(String errorMessage) {
    return SearchState(
      filter: filter,
      searchResults: searchResults,
      isLoading: false,
      error: errorMessage,
    );
  }
}

/// 搜索状态管理器
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(SearchState());

  /// 更新搜索关键词
  void updateKeyword(String keyword) {
    final newFilter = state.filter.copyWith(keyword: keyword);
    state = state.copyWithFilter(newFilter);
  }

  /// 更新区域筛选
  void updateArea(String? area) {
    final newFilter = state.filter.copyWith(area: area);
    state = state.copyWithFilter(newFilter);
    search();
  }

  /// 更新价格范围筛选
  void updatePriceRange(PriceRange? priceRange) {
    final newFilter = state.filter.copyWith(priceRange: priceRange);
    state = state.copyWithFilter(newFilter);
    search();
  }

  /// 更新户型筛选
  void updateHouseType(String? houseType) {
    final newFilter = state.filter.copyWith(houseType: houseType);
    state = state.copyWithFilter(newFilter);
    search();
  }

  /// 更新标签筛选
  void updateTags(List<String> tags) {
    final newFilter = state.filter.copyWith(tags: tags);
    state = state.copyWithFilter(newFilter);
    search();
  }

  /// 添加标签
  void addTag(String tag) {
    if (!state.filter.tags.contains(tag)) {
      final newTags = [...state.filter.tags, tag];
      updateTags(newTags);
    }
  }

  /// 移除标签
  void removeTag(String tag) {
    if (state.filter.tags.contains(tag)) {
      final newTags = [...state.filter.tags]..remove(tag);
      updateTags(newTags);
    }
  }

  /// 清除所有筛选条件
  void clearFilters() {
    state = state.copyWithFilter(SearchFilterModel());
    search();
  }

  /// 执行搜索
  Future<void> search() async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));

      // 模拟搜索结果
      final results = _getMockSearchResults();

      // 应用筛选条件
      final filteredResults = _applyFilters(results);

      state = state.copyWithResults(filteredResults);
    } catch (e) {
      state = state.copyWithError('搜索失败: ${e.toString()}');
    }
  }

  /// 获取模拟搜索结果
  List<HouseModel> _getMockSearchResults() {
    return [
      HouseModel(
        id: '1',
        title: '精装修一居室 近地铁 拎包入住',
        location: '朝阳区 - 望京',
        district: '朝阳区',
        description: '此房为精装修一居室，家具家电齐全，拎包入住。小区环境优美，周边配套设施完善，交通便利，紧邻地铁15号线。',
        price: 4500,
        roomType: '1室1厅',
        area: 55,
        floor: '2/18层',
        direction: '南',
        tags: ['近地铁', '拎包入住', '精装修'],
      ),
      HouseModel(
        id: '2',
        title: '阳光花园 两居室 南北通透',
        location: '海淀区 - 中关村',
        district: '海淀区',
        description: '此房南北通透，采光良好，业主诚心出租，看房方便。',
        price: 3800,
        roomType: '2室1厅',
        area: 75,
        floor: '5/24层',
        direction: '南北',
        tags: ['南北通透', '阳光充足', '生活便利'],
      ),
      HouseModel(
        id: '3',
        title: '合租·银河SOHO 3居室 朝南',
        location: '东城区 - 银河SOHO',
        district: '东城区',
        description: '合租房间，3居室中的一间，房间朝南，光线充足。厨卫公用，拎包入住。',
        price: 3800,
        roomType: '3室1厅',
        area: 20,
        floor: '10/20层',
        direction: '南',
        tags: ['合租', '朝南', '拎包入住'],
      ),
      HouseModel(
        id: '4',
        title: '豪华三居室 全新装修 高层景观房',
        location: '朝阳区 - CBD',
        district: '朝阳区',
        description: '高档小区，三居室，全新豪华装修，视野开阔，配套设施齐全。',
        price: 12000,
        roomType: '3室2厅',
        area: 140,
        floor: '25/32层',
        direction: '东南',
        tags: ['豪华装修', '高层景观', '品质小区'],
      ),
      HouseModel(
        id: '5',
        title: '温馨一居室 紧邻地铁 配套齐全',
        location: '大兴区 - 亦庄',
        district: '大兴区',
        description: '此房紧邻地铁站，出行便利，周边配套齐全，拎包入住。',
        price: 3200,
        roomType: '1室1厅',
        area: 50,
        floor: '6/18层',
        direction: '南',
        tags: ['近地铁', '拎包入住', '配套齐全'],
      ),
    ];
  }

  /// 应用筛选条件
  List<HouseModel> _applyFilters(List<HouseModel> houses) {
    final filter = state.filter;

    return houses.where((house) {
      // 关键词筛选
      if (filter.keyword != null && filter.keyword!.isNotEmpty) {
        final keyword = filter.keyword!.toLowerCase();
        final titleMatches = house.title.toLowerCase().contains(keyword);
        final locationMatches = house.location.toLowerCase().contains(keyword);
        final districtMatches = house.district.toLowerCase().contains(keyword);

        if (!titleMatches && !locationMatches && !districtMatches) {
          return false;
        }
      }

      // 区域筛选
      if (filter.area != null && filter.area!.isNotEmpty) {
        if (!house.district.contains(filter.area!)) {
          return false;
        }
      }

      // 价格范围筛选
      if (filter.priceRange != null) {
        if (filter.priceRange!.min != null &&
            house.price < filter.priceRange!.min!) {
          return false;
        }
        if (filter.priceRange!.max != null &&
            house.price > filter.priceRange!.max!) {
          return false;
        }
      }

      // 户型筛选
      if (filter.houseType != null && filter.houseType!.isNotEmpty) {
        if (house.roomType != filter.houseType) {
          return false;
        }
      }

      // 标签筛选
      if (filter.tags.isNotEmpty) {
        // 检查是否包含所有选中的标签
        for (final tag in filter.tags) {
          if (!house.tags.contains(tag)) {
            return false;
          }
        }
      }

      return true;
    }).toList();
  }
}

/// 搜索状态提供者
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  return SearchNotifier();
});
