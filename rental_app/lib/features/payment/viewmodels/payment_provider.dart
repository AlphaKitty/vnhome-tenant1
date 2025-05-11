import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_record_model.dart';

/// 支付记录标签选项
enum PaymentTabOption {
  /// 全部记录
  all,

  /// 待付款
  pending,

  /// 已完成
  completed,
}

/// 支付记录状态
class PaymentState {
  final List<PaymentRecordModel> paymentRecords;
  final PaymentTabOption selectedTab;
  final bool isLoading;
  final String? error;

  const PaymentState({
    this.paymentRecords = const [],
    this.selectedTab = PaymentTabOption.all,
    this.isLoading = false,
    this.error,
  });

  /// 创建加载状态
  PaymentState copyWithLoading() {
    return PaymentState(
      paymentRecords: paymentRecords,
      selectedTab: selectedTab,
      isLoading: true,
      error: null,
    );
  }

  /// 创建错误状态
  PaymentState copyWithError(String errorMessage) {
    return PaymentState(
      paymentRecords: paymentRecords,
      selectedTab: selectedTab,
      isLoading: false,
      error: errorMessage,
    );
  }

  /// 更新记录列表
  PaymentState copyWithRecords(List<PaymentRecordModel> records) {
    return PaymentState(
      paymentRecords: records,
      selectedTab: selectedTab,
      isLoading: false,
      error: null,
    );
  }

  /// 更新选中的标签
  PaymentState copyWithSelectedTab(PaymentTabOption tab) {
    return PaymentState(
      paymentRecords: paymentRecords,
      selectedTab: tab,
      isLoading: isLoading,
      error: error,
    );
  }

  /// 获取当前标签下的记录列表
  List<PaymentRecordModel> get filteredRecords {
    switch (selectedTab) {
      case PaymentTabOption.pending:
        return paymentRecords
            .where((record) => record.status == PaymentStatus.pending)
            .toList();
      case PaymentTabOption.completed:
        return paymentRecords
            .where(
              (record) =>
                  record.status == PaymentStatus.success ||
                  record.status == PaymentStatus.refunded,
            )
            .toList();
      case PaymentTabOption.all:
      default:
        return paymentRecords;
    }
  }
}

/// 支付记录状态提供者
class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier() : super(const PaymentState());

  /// 加载支付记录
  Future<void> loadPaymentRecords() async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      // 获取模拟数据
      final paymentRecords = _getMockPaymentRecords();

      state = state.copyWithRecords(paymentRecords);
    } catch (e) {
      state = state.copyWithError('加载支付记录失败: ${e.toString()}');
    }
  }

  /// 切换记录类型标签
  void selectTab(PaymentTabOption tab) {
    state = state.copyWithSelectedTab(tab);
  }

  /// 获取模拟支付记录
  List<PaymentRecordModel> _getMockPaymentRecords() {
    final now = DateTime.now();

    return [
      // 已支付记录
      PaymentRecordModel(
        id: '1',
        orderId: 'OR2023120001',
        title: '12月租金',
        houseId: '1',
        houseName: '精装修一居室 近地铁 拎包入住',
        amount: 4500.0,
        paymentTime: now.subtract(const Duration(days: 5)),
        type: PaymentType.rent,
        status: PaymentStatus.success,
      ),
      PaymentRecordModel(
        id: '2',
        orderId: 'OR2023110001',
        title: '11月租金',
        houseId: '1',
        houseName: '精装修一居室 近地铁 拎包入住',
        amount: 4500.0,
        paymentTime: now.subtract(const Duration(days: 35)),
        type: PaymentType.rent,
        status: PaymentStatus.success,
      ),
      PaymentRecordModel(
        id: '3',
        orderId: 'OR2023100001',
        title: '10月租金',
        houseId: '1',
        houseName: '精装修一居室 近地铁 拎包入住',
        amount: 4500.0,
        paymentTime: now.subtract(const Duration(days: 65)),
        type: PaymentType.rent,
        status: PaymentStatus.success,
      ),
      // 押金
      PaymentRecordModel(
        id: '4',
        orderId: 'OR2023090002',
        title: '房屋押金',
        houseId: '1',
        houseName: '精装修一居室 近地铁 拎包入住',
        amount: 4500.0,
        paymentTime: now.subtract(const Duration(days: 95)),
        type: PaymentType.deposit,
        status: PaymentStatus.success,
      ),
      // 待支付记录
      PaymentRecordModel(
        id: '5',
        orderId: 'OR2024010001',
        title: '1月租金',
        houseId: '1',
        houseName: '精装修一居室 近地铁 拎包入住',
        amount: 4500.0,
        paymentTime: now.add(const Duration(days: 2)),
        type: PaymentType.rent,
        status: PaymentStatus.pending,
      ),
      PaymentRecordModel(
        id: '6',
        orderId: 'OR2024010002',
        title: '物业服务费',
        houseId: '1',
        houseName: '精装修一居室 近地铁 拎包入住',
        amount: 120.0,
        paymentTime: now.add(const Duration(days: 5)),
        type: PaymentType.serviceFee,
        status: PaymentStatus.pending,
      ),
      // 退款记录
      PaymentRecordModel(
        id: '7',
        orderId: 'OR2023060001',
        title: '多收水电费退款',
        houseId: '2',
        houseName: '阳光花园 两居室 南北通透',
        amount: 237.5,
        paymentTime: now.subtract(const Duration(days: 120)),
        type: PaymentType.other,
        status: PaymentStatus.refunded,
        remark: '水电费多收部分退款',
      ),
    ];
  }
}

/// 支付记录状态提供者
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((
  ref,
) {
  return PaymentNotifier();
});
