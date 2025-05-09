import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/house_model.dart';

/// 房源列表状态
class HouseListState {
  final List<HouseModel> houses;
  final bool isLoading;
  final String? error;

  HouseListState({this.houses = const [], this.isLoading = false, this.error});

  /// 创建加载状态
  HouseListState copyWithLoading() {
    return HouseListState(houses: houses, isLoading: true, error: null);
  }

  /// 创建加载成功状态
  HouseListState copyWithData(List<HouseModel> houses) {
    return HouseListState(houses: houses, isLoading: false, error: null);
  }

  /// 创建错误状态
  HouseListState copyWithError(String errorMessage) {
    return HouseListState(
      houses: houses,
      isLoading: false,
      error: errorMessage,
    );
  }
}

/// 房源列表状态管理器
class HouseListNotifier extends StateNotifier<HouseListState> {
  HouseListNotifier() : super(HouseListState()) {
    // 初始化时加载房源数据
    fetchHouses();
  }

  /// 获取房源列表
  Future<void> fetchHouses() async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求获取房源数据
      await Future.delayed(const Duration(seconds: 1));

      // 创建模拟数据
      final houses = [
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
      ];

      state = state.copyWithData(houses);
    } catch (e) {
      state = state.copyWithError('获取房源失败: ${e.toString()}');
    }
  }

  /// 切换房源收藏状态
  void toggleFavorite(String houseId) {
    final updatedHouses =
        state.houses.map((house) {
          if (house.id == houseId) {
            return house.toggleFavorite();
          }
          return house;
        }).toList();

    state = state.copyWithData(updatedHouses);
  }

  /// 获取房源详情
  HouseModel? getHouseById(String id) {
    try {
      return state.houses.firstWhere((house) => house.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// 房源列表提供者
final houseListProvider =
    StateNotifierProvider<HouseListNotifier, HouseListState>((ref) {
      return HouseListNotifier();
    });

/// 房源详情提供者
final houseDetailProvider = Provider.family<HouseModel?, String>((ref, id) {
  return ref.watch(houseListProvider.notifier).getHouseById(id);
});
