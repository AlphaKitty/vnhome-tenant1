/// 合同状态枚举
enum ContractStatus {
  /// 待签约
  pending,

  /// 已生效
  active,

  /// 已到期
  expired,

  /// 已终止
  terminated,
}

/// 合同模型
class ContractModel {
  final String id;
  final String houseId;
  final String houseName;
  final String houseAddress;
  final String landlordId;
  final String landlordName;
  final String landlordPhone;
  final String landlordIdCard;
  final String tenantId;
  final String tenantName;
  final String tenantPhone;
  final String tenantIdCard;
  final DateTime startDate;
  final DateTime endDate;
  final double rentPrice;
  final double depositPrice;
  final String paymentCycle;
  final int paymentDay;
  final ContractStatus status;
  final DateTime signDate;
  final List<String> terms;
  final String? remark;

  /// 构造函数
  const ContractModel({
    required this.id,
    required this.houseId,
    required this.houseName,
    required this.houseAddress,
    required this.landlordId,
    required this.landlordName,
    required this.landlordPhone,
    required this.landlordIdCard,
    required this.tenantId,
    required this.tenantName,
    required this.tenantPhone,
    required this.tenantIdCard,
    required this.startDate,
    required this.endDate,
    required this.rentPrice,
    required this.depositPrice,
    required this.paymentCycle,
    required this.paymentDay,
    required this.status,
    required this.signDate,
    required this.terms,
    this.remark,
  });

  /// 从JSON映射创建合同模型
  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] as String,
      houseId: json['houseId'] as String,
      houseName: json['houseName'] as String,
      houseAddress: json['houseAddress'] as String,
      landlordId: json['landlordId'] as String,
      landlordName: json['landlordName'] as String,
      landlordPhone: json['landlordPhone'] as String,
      landlordIdCard: json['landlordIdCard'] as String,
      tenantId: json['tenantId'] as String,
      tenantName: json['tenantName'] as String,
      tenantPhone: json['tenantPhone'] as String,
      tenantIdCard: json['tenantIdCard'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      rentPrice: (json['rentPrice'] as num).toDouble(),
      depositPrice: (json['depositPrice'] as num).toDouble(),
      paymentCycle: json['paymentCycle'] as String,
      paymentDay: json['paymentDay'] as int,
      status: _parseContractStatus(json['status'] as String),
      signDate: DateTime.parse(json['signDate'] as String),
      terms: (json['terms'] as List<dynamic>).map((e) => e as String).toList(),
      remark: json['remark'] as String?,
    );
  }

  /// 解析合同状态
  static ContractStatus _parseContractStatus(String statusStr) {
    switch (statusStr) {
      case 'pending':
        return ContractStatus.pending;
      case 'active':
        return ContractStatus.active;
      case 'expired':
        return ContractStatus.expired;
      case 'terminated':
        return ContractStatus.terminated;
      default:
        return ContractStatus.pending;
    }
  }

  /// 转换为JSON映射
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'houseId': houseId,
      'houseName': houseName,
      'houseAddress': houseAddress,
      'landlordId': landlordId,
      'landlordName': landlordName,
      'landlordPhone': landlordPhone,
      'landlordIdCard': landlordIdCard,
      'tenantId': tenantId,
      'tenantName': tenantName,
      'tenantPhone': tenantPhone,
      'tenantIdCard': tenantIdCard,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'rentPrice': rentPrice,
      'depositPrice': depositPrice,
      'paymentCycle': paymentCycle,
      'paymentDay': paymentDay,
      'status': _contractStatusToString(status),
      'signDate': signDate.toIso8601String(),
      'terms': terms,
      'remark': remark,
    };
  }

  /// 将合同状态转换为字符串
  static String _contractStatusToString(ContractStatus status) {
    switch (status) {
      case ContractStatus.pending:
        return 'pending';
      case ContractStatus.active:
        return 'active';
      case ContractStatus.expired:
        return 'expired';
      case ContractStatus.terminated:
        return 'terminated';
    }
  }

  /// 创建一个合同副本
  ContractModel copyWith({
    String? id,
    String? houseId,
    String? houseName,
    String? houseAddress,
    String? landlordId,
    String? landlordName,
    String? landlordPhone,
    String? landlordIdCard,
    String? tenantId,
    String? tenantName,
    String? tenantPhone,
    String? tenantIdCard,
    DateTime? startDate,
    DateTime? endDate,
    double? rentPrice,
    double? depositPrice,
    String? paymentCycle,
    int? paymentDay,
    ContractStatus? status,
    DateTime? signDate,
    List<String>? terms,
    String? remark,
  }) {
    return ContractModel(
      id: id ?? this.id,
      houseId: houseId ?? this.houseId,
      houseName: houseName ?? this.houseName,
      houseAddress: houseAddress ?? this.houseAddress,
      landlordId: landlordId ?? this.landlordId,
      landlordName: landlordName ?? this.landlordName,
      landlordPhone: landlordPhone ?? this.landlordPhone,
      landlordIdCard: landlordIdCard ?? this.landlordIdCard,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
      tenantPhone: tenantPhone ?? this.tenantPhone,
      tenantIdCard: tenantIdCard ?? this.tenantIdCard,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rentPrice: rentPrice ?? this.rentPrice,
      depositPrice: depositPrice ?? this.depositPrice,
      paymentCycle: paymentCycle ?? this.paymentCycle,
      paymentDay: paymentDay ?? this.paymentDay,
      status: status ?? this.status,
      signDate: signDate ?? this.signDate,
      terms: terms ?? this.terms,
      remark: remark ?? this.remark,
    );
  }
}
