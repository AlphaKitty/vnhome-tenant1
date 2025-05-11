/// 支付类型枚举
enum PaymentType {
  /// 租金支付
  rent,

  /// 押金支付
  deposit,

  /// 服务费
  serviceFee,

  /// 其他费用
  other,
}

/// 支付状态枚举
enum PaymentStatus {
  /// 待支付
  pending,

  /// 支付成功
  success,

  /// 支付失败
  failed,

  /// 已取消
  canceled,

  /// 已退款
  refunded,
}

/// 支付记录模型
class PaymentRecordModel {
  final String id;
  final String orderId;
  final String title;
  final String houseId;
  final String houseName;
  final double amount;
  final DateTime paymentTime;
  final PaymentType type;
  final PaymentStatus status;
  final String? remark;

  const PaymentRecordModel({
    required this.id,
    required this.orderId,
    required this.title,
    required this.houseId,
    required this.houseName,
    required this.amount,
    required this.paymentTime,
    required this.type,
    required this.status,
    this.remark,
  });

  /// 从JSON映射创建支付记录模型
  factory PaymentRecordModel.fromJson(Map<String, dynamic> json) {
    return PaymentRecordModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      title: json['title'] as String,
      houseId: json['houseId'] as String,
      houseName: json['houseName'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentTime: DateTime.parse(json['paymentTime'] as String),
      type: _parsePaymentType(json['type'] as String),
      status: _parsePaymentStatus(json['status'] as String),
      remark: json['remark'] as String?,
    );
  }

  /// 解析支付类型
  static PaymentType _parsePaymentType(String typeStr) {
    switch (typeStr) {
      case 'rent':
        return PaymentType.rent;
      case 'deposit':
        return PaymentType.deposit;
      case 'serviceFee':
        return PaymentType.serviceFee;
      case 'other':
      default:
        return PaymentType.other;
    }
  }

  /// 解析支付状态
  static PaymentStatus _parsePaymentStatus(String statusStr) {
    switch (statusStr) {
      case 'pending':
        return PaymentStatus.pending;
      case 'success':
        return PaymentStatus.success;
      case 'failed':
        return PaymentStatus.failed;
      case 'canceled':
        return PaymentStatus.canceled;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  /// 转换为JSON映射
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'title': title,
      'houseId': houseId,
      'houseName': houseName,
      'amount': amount,
      'paymentTime': paymentTime.toIso8601String(),
      'type': _paymentTypeToString(type),
      'status': _paymentStatusToString(status),
      'remark': remark,
    };
  }

  /// 将支付类型转换为字符串
  static String _paymentTypeToString(PaymentType type) {
    switch (type) {
      case PaymentType.rent:
        return 'rent';
      case PaymentType.deposit:
        return 'deposit';
      case PaymentType.serviceFee:
        return 'serviceFee';
      case PaymentType.other:
        return 'other';
    }
  }

  /// 将支付状态转换为字符串
  static String _paymentStatusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.success:
        return 'success';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.canceled:
        return 'canceled';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }

  /// 创建一个支付记录副本
  PaymentRecordModel copyWith({
    String? id,
    String? orderId,
    String? title,
    String? houseId,
    String? houseName,
    double? amount,
    DateTime? paymentTime,
    PaymentType? type,
    PaymentStatus? status,
    String? remark,
  }) {
    return PaymentRecordModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      title: title ?? this.title,
      houseId: houseId ?? this.houseId,
      houseName: houseName ?? this.houseName,
      amount: amount ?? this.amount,
      paymentTime: paymentTime ?? this.paymentTime,
      type: type ?? this.type,
      status: status ?? this.status,
      remark: remark ?? this.remark,
    );
  }
}
