import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/features/house/models/house_model.dart';
import '../models/favorite_model.dart';

/// 收藏记录标签选项
enum FavoriteTabOption {
  /// 全部收藏
  favorite,

  /// 最近浏览
  history,
}

/// 收藏状态
class FavoriteState {
  final List<FavoriteRecordModel> favoriteRecords;
  final List<FavoriteRecordModel> historyRecords;
  final FavoriteTabOption selectedTab;
  final bool isLoading;
  final String? error;

  const FavoriteState({
    this.favoriteRecords = const [],
    this.historyRecords = const [],
    this.selectedTab = FavoriteTabOption.favorite,
    this.isLoading = false,
    this.error,
  });

  /// 创建加载状态
  FavoriteState copyWithLoading() {
    return FavoriteState(
      favoriteRecords: favoriteRecords,
      historyRecords: historyRecords,
      selectedTab: selectedTab,
      isLoading: true,
      error: null,
    );
  }

  /// 创建错误状态
  FavoriteState copyWithError(String errorMessage) {
    return FavoriteState(
      favoriteRecords: favoriteRecords,
      historyRecords: historyRecords,
      selectedTab: selectedTab,
      isLoading: false,
      error: errorMessage,
    );
  }

  /// 更新记录列表
  FavoriteState copyWithRecords({
    List<FavoriteRecordModel>? favoriteRecords,
    List<FavoriteRecordModel>? historyRecords,
  }) {
    return FavoriteState(
      favoriteRecords: favoriteRecords ?? this.favoriteRecords,
      historyRecords: historyRecords ?? this.historyRecords,
      selectedTab: selectedTab,
      isLoading: false,
      error: null,
    );
  }

  /// 更新选中的标签
  FavoriteState copyWithSelectedTab(FavoriteTabOption tab) {
    return FavoriteState(
      favoriteRecords: favoriteRecords,
      historyRecords: historyRecords,
      selectedTab: tab,
      isLoading: isLoading,
      error: error,
    );
  }

  /// 获取当前标签的记录列表
  List<FavoriteRecordModel> get currentRecords {
    return selectedTab == FavoriteTabOption.favorite
        ? favoriteRecords
        : historyRecords;
  }
}

/// 收藏状态提供者
class FavoriteNotifier extends StateNotifier<FavoriteState> {
  FavoriteNotifier() : super(const FavoriteState());

  /// 加载收藏和历史记录
  Future<void> loadRecords() async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      // 获取模拟数据
      final favoriteRecords = _getMockFavorites();
      final historyRecords = _getMockHistory();

      state = state.copyWithRecords(
        favoriteRecords: favoriteRecords,
        historyRecords: historyRecords,
      );
    } catch (e) {
      state = state.copyWithError('加载收藏记录失败: ${e.toString()}');
    }
  }

  /// 切换记录类型标签
  void selectTab(FavoriteTabOption tab) {
    state = state.copyWithSelectedTab(tab);
  }

  /// 添加收藏记录
  Future<void> addFavorite(HouseModel house) async {
    // 检查是否已收藏
    final existingFavorite =
        state.favoriteRecords
            .where((record) => record.houseId == house.id)
            .toList();

    if (existingFavorite.isNotEmpty) {
      // 如果已收藏，则更新时间
      final updatedRecord = existingFavorite.first.withUpdatedTimestamp();
      final updatedRecords = [...state.favoriteRecords];
      final index = updatedRecords.indexOf(existingFavorite.first);
      updatedRecords[index] = updatedRecord;

      state = state.copyWithRecords(favoriteRecords: updatedRecords);
      return;
    }

    // 创建新收藏记录
    final newRecord = FavoriteRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      houseId: house.id,
      timestamp: DateTime.now(),
      type: FavoriteRecordType.favorite,
      house: house,
    );

    // 更新状态
    state = state.copyWithRecords(
      favoriteRecords: [...state.favoriteRecords, newRecord],
    );
  }

  /// 添加浏览记录
  Future<void> addHistory(HouseModel house) async {
    // 检查是否已存在记录
    final existingHistory =
        state.historyRecords
            .where((record) => record.houseId == house.id)
            .toList();

    if (existingHistory.isNotEmpty) {
      // 如果已存在，则更新时间
      final updatedRecord = existingHistory.first.withUpdatedTimestamp();
      final updatedRecords = [...state.historyRecords];
      final index = updatedRecords.indexOf(existingHistory.first);
      updatedRecords[index] = updatedRecord;

      state = state.copyWithRecords(historyRecords: updatedRecords);
      return;
    }

    // 创建新浏览记录
    final newRecord = FavoriteRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      houseId: house.id,
      timestamp: DateTime.now(),
      type: FavoriteRecordType.history,
      house: house,
    );

    // 更新状态
    state = state.copyWithRecords(
      historyRecords: [...state.historyRecords, newRecord],
    );
  }

  /// 移除收藏记录
  Future<void> removeFavorite(String recordId) async {
    final updatedRecords =
        state.favoriteRecords.where((record) => record.id != recordId).toList();

    state = state.copyWithRecords(favoriteRecords: updatedRecords);
  }

  /// 移除浏览记录
  Future<void> removeHistory(String recordId) async {
    final updatedRecords =
        state.historyRecords.where((record) => record.id != recordId).toList();

    state = state.copyWithRecords(historyRecords: updatedRecords);
  }

  /// 清空浏览记录
  Future<void> clearHistory() async {
    state = state.copyWithRecords(historyRecords: []);
  }

  /// 检查房源是否已收藏
  bool isFavorite(String houseId) {
    return state.favoriteRecords.any((record) => record.houseId == houseId);
  }

  /// 获取模拟收藏记录
  List<FavoriteRecordModel> _getMockFavorites() {
    final now = DateTime.now();

    return [
      FavoriteRecordModel(
        id: '1',
        houseId: '1',
        timestamp: now.subtract(const Duration(days: 1)),
        type: FavoriteRecordType.favorite,
        house: HouseModel(
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
      ),
      FavoriteRecordModel(
        id: '2',
        houseId: '2',
        timestamp: now.subtract(const Duration(days: 2)),
        type: FavoriteRecordType.favorite,
        house: HouseModel(
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
      ),
      FavoriteRecordModel(
        id: '3',
        houseId: '4',
        timestamp: now.subtract(const Duration(days: 3)),
        type: FavoriteRecordType.favorite,
        house: HouseModel(
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
      ),
    ];
  }

  /// 获取模拟浏览记录
  List<FavoriteRecordModel> _getMockHistory() {
    final now = DateTime.now();

    return [
      FavoriteRecordModel(
        id: '4',
        houseId: '3',
        timestamp: now.subtract(const Duration(hours: 1)),
        type: FavoriteRecordType.history,
        house: HouseModel(
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
      ),
      FavoriteRecordModel(
        id: '5',
        houseId: '5',
        timestamp: now.subtract(const Duration(hours: 3)),
        type: FavoriteRecordType.history,
        house: HouseModel(
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
      ),
      FavoriteRecordModel(
        id: '6',
        houseId: '1',
        timestamp: now.subtract(const Duration(days: 2)),
        type: FavoriteRecordType.history,
        house: HouseModel(
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
      ),
    ];
  }
}

/// 收藏状态提供者
final favoriteProvider = StateNotifierProvider<FavoriteNotifier, FavoriteState>(
  (ref) {
    return FavoriteNotifier();
  },
);
