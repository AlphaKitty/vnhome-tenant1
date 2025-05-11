import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contract_model.dart';

/// 合同状态
class ContractState {
  final ContractModel? contract;
  final bool isLoading;
  final String? error;

  const ContractState({this.contract, this.isLoading = false, this.error});

  /// 创建加载状态
  ContractState copyWithLoading() {
    return ContractState(contract: contract, isLoading: true, error: null);
  }

  /// 创建错误状态
  ContractState copyWithError(String errorMessage) {
    return ContractState(
      contract: contract,
      isLoading: false,
      error: errorMessage,
    );
  }

  /// 更新合同
  ContractState copyWithContract(ContractModel contract) {
    return ContractState(contract: contract, isLoading: false, error: null);
  }
}

/// 合同状态管理器
class ContractNotifier extends StateNotifier<ContractState> {
  ContractNotifier() : super(const ContractState());

  /// 加载当前合同
  Future<void> loadCurrentContract() async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      // 获取模拟合同数据
      final contract = _getMockContract();

      state = state.copyWithContract(contract);
    } catch (e) {
      state = state.copyWithError('加载合同失败: ${e.toString()}');
    }
  }

  /// 获取模拟合同数据
  ContractModel _getMockContract() {
    // 创建一个模拟的合同数据
    return ContractModel(
      id: 'CONTRACT001',
      houseId: '1',
      houseName: '精装修一居室 近地铁 拎包入住',
      houseAddress: '朝阳区望京SOHO T1，精装修一居室',
      landlordId: 'LANDLORD001',
      landlordName: '王先生',
      landlordPhone: '138****5678',
      landlordIdCard: '1101**************',
      tenantId: 'TENANT001',
      tenantName: '张三',
      tenantPhone: '139****1234',
      tenantIdCard: '1201**************',
      startDate: DateTime(2023, 1, 15),
      endDate: DateTime(2024, 1, 14),
      rentPrice: 4500.0,
      depositPrice: 4500.0,
      paymentCycle: '月付',
      paymentDay: 10,
      status: ContractStatus.active,
      signDate: DateTime(2023, 1, 10),
      terms: [
        '1. 租赁期限：自2023年1月15日起至2024年1月14日止，共计12个月；',
        '2. 付款方式：月付，每月租金为人民币4,500元整，乙方应于每月10日前支付当月租金；',
        '3. 押金：乙方支付押金9,000元，合同期满，房屋验收合格后，甲方应将押金无息退还乙方；',
        '4. 乙方逾期支付租金，每逾期一日，应向甲方支付日租金的5%作为滞纳金；',
        '5. 甲方未按约定提供合格房屋，乙方有权解除合同，甲方应双倍返还已收押金；',
        '6. 乙方不得擅自改变房屋结构及用途，不得擅自转租；',
        '7. 合同期满，乙方如需继续租赁，应提前30日向甲方提出，协商一致后重新签订租赁合同。',
      ],
      remark: '本合同一式两份，甲、乙双方各执一份，具有同等法律效力。',
    );
  }
}

/// 合同状态提供者
final contractProvider = StateNotifierProvider<ContractNotifier, ContractState>(
  (ref) {
    return ContractNotifier();
  },
);
