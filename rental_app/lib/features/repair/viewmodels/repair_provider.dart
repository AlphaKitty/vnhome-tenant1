import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/repair_model.dart';

/// 报修记录状态
class RepairState {
  final List<RepairModel> repairRecords;
  final bool isLoading;
  final String? error;
  final RepairStatus? filterStatus;

  const RepairState({
    this.repairRecords = const [],
    this.isLoading = false,
    this.error,
    this.filterStatus,
  });

  /// 创建加载状态
  RepairState copyWithLoading() {
    return RepairState(
      repairRecords: repairRecords,
      isLoading: true,
      error: null,
      filterStatus: filterStatus,
    );
  }

  /// 创建错误状态
  RepairState copyWithError(String errorMessage) {
    return RepairState(
      repairRecords: repairRecords,
      isLoading: false,
      error: errorMessage,
      filterStatus: filterStatus,
    );
  }

  /// 更新记录列表
  RepairState copyWithRecords(List<RepairModel> records) {
    return RepairState(
      repairRecords: records,
      isLoading: false,
      error: null,
      filterStatus: filterStatus,
    );
  }

  /// 更新过滤状态
  RepairState copyWithFilterStatus(RepairStatus? status) {
    return RepairState(
      repairRecords: repairRecords,
      isLoading: isLoading,
      error: error,
      filterStatus: status,
    );
  }

  /// 获取过滤后的记录列表
  List<RepairModel> get filteredRecords {
    if (filterStatus == null) {
      return repairRecords;
    }

    return repairRecords
        .where((record) => record.status == filterStatus)
        .toList();
  }
}

/// 报修记录状态提供者
class RepairNotifier extends StateNotifier<RepairState> {
  RepairNotifier() : super(const RepairState());

  /// 加载报修记录
  Future<void> loadRepairRecords() async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      // 获取模拟数据
      final repairRecords = _getMockRepairRecords();

      state = state.copyWithRecords(repairRecords);
    } catch (e) {
      state = state.copyWithError('加载报修记录失败: ${e.toString()}');
    }
  }

  /// 设置过滤状态
  void setFilterStatus(RepairStatus? status) {
    state = state.copyWithFilterStatus(status);
  }

  /// 添加报修记录
  Future<bool> addRepairRecord({
    required String houseId,
    required String houseName,
    required String description,
    required RepairType type,
    DateTime? expectedTime,
    List<String> imageUrls = const [],
  }) async {
    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      // 创建新的报修记录
      final newRecord = RepairModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // 使用时间戳作为临时ID
        houseId: houseId,
        houseName: houseName,
        description: description,
        type: type,
        status: RepairStatus.pending,
        submitTime: DateTime.now(),
        expectedTime: expectedTime,
        imageUrls: imageUrls,
      );

      // 将新记录添加到列表首位
      final updatedRecords = [newRecord, ...state.repairRecords];

      state = state.copyWithRecords(updatedRecords);
      return true;
    } catch (e) {
      state = state.copyWithError('提交报修失败: ${e.toString()}');
      return false;
    }
  }

  /// 取消报修请求
  Future<bool> cancelRepairRequest(String repairId) async {
    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      final updatedRecords =
          state.repairRecords.map((record) {
            if (record.id == repairId) {
              return record.copyWith(status: RepairStatus.cancelled);
            }
            return record;
          }).toList();

      state = state.copyWithRecords(updatedRecords);
      return true;
    } catch (e) {
      state = state.copyWithError('取消报修失败: ${e.toString()}');
      return false;
    }
  }

  /// 获取模拟报修记录
  List<RepairModel> _getMockRepairRecords() {
    final now = DateTime.now();

    return [
      // 处理中的记录
      RepairModel(
        id: '1',
        houseId: '1',
        houseName: '朝阳区 - 望京 精装修一居室',
        description: '厨房水龙头漏水，影响正常使用，请尽快处理。',
        type: RepairType.plumbing,
        status: RepairStatus.processing,
        submitTime: now.subtract(const Duration(days: 2)),
        expectedTime: now.add(const Duration(days: 1)),
        imageUrls: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
      ),

      // 已完成的记录
      RepairModel(
        id: '2',
        houseId: '1',
        houseName: '朝阳区 - 望京 精装修一居室',
        description: '卧室空调开启后不制冷，可能需要加氟利昂。',
        type: RepairType.airConditioner,
        status: RepairStatus.completed,
        submitTime: now.subtract(const Duration(days: 20)),
        expectedTime: now.subtract(const Duration(days: 19)),
        remark: '已维修完成，空调恢复正常使用。',
      ),

      // 已完成的记录
      RepairModel(
        id: '3',
        houseId: '1',
        houseName: '朝阳区 - 望京 精装修一居室',
        description: '卫生间门锁损坏，无法正常锁门。',
        type: RepairType.lock,
        status: RepairStatus.completed,
        submitTime: now.subtract(const Duration(days: 45)),
        expectedTime: now.subtract(const Duration(days: 44)),
        remark: '已更换新锁具。',
      ),

      // 已取消的记录
      RepairModel(
        id: '4',
        houseId: '2',
        houseName: '海淀区 - 中关村 阳光花园 两居室',
        description: '网络信号不稳定，经常断网。',
        type: RepairType.network,
        status: RepairStatus.cancelled,
        submitTime: now.subtract(const Duration(days: 60)),
        expectedTime: now.subtract(const Duration(days: 58)),
        remark: '用户自行解决，取消申请。',
      ),
    ];
  }
}

/// 报修记录状态提供者
final repairProvider = StateNotifierProvider<RepairNotifier, RepairState>((
  ref,
) {
  return RepairNotifier();
});
