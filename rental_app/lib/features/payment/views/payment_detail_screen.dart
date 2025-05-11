import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/shared/widgets/app_bar_widget.dart';
import '../models/payment_record_model.dart';
import '../viewmodels/payment_provider.dart';

/// 支付详情页面
class PaymentDetailScreen extends ConsumerWidget {
  /// 支付记录ID
  final String paymentId;

  const PaymentDetailScreen({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentProvider);
    final record = paymentState.paymentRecords.firstWhere(
      (record) => record.id == paymentId,
      orElse:
          () => PaymentRecordModel(
            id: '',
            orderId: '',
            title: '未找到记录',
            houseId: '',
            houseName: '',
            amount: 0,
            paymentTime: DateTime.now(),
            type: PaymentType.other,
            status: PaymentStatus.failed,
          ),
    );

    if (record.id.isEmpty) {
      return Scaffold(
        appBar: const AppBarWidget(title: '支付详情', showBackButton: true),
        body: const Center(child: Text('未找到支付记录')),
      );
    }

    return Scaffold(
      appBar: const AppBarWidget(title: '支付详情', showBackButton: true),
      body: _buildPaymentDetail(context, record),
    );
  }

  /// 构建支付详情内容
  Widget _buildPaymentDetail(BuildContext context, PaymentRecordModel record) {
    final theme = Theme.of(context);
    final (statusColor, statusText) = _getStatusInfo(record.status);
    final isSuccess =
        record.status == PaymentStatus.success ||
        record.status == PaymentStatus.refunded;
    final isPending = record.status == PaymentStatus.pending;

    return SingleChildScrollView(
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 状态卡片
          _buildStatusCard(context, record, statusColor, statusText, isSuccess),
          SizedBox(height: DesignTokens.spacingLarge),

          // 订单信息
          _buildSectionTitle(context, '订单信息'),
          _buildOrderInfoCard(context, record),
          SizedBox(height: DesignTokens.spacingLarge),

          // 支付信息
          _buildSectionTitle(context, '支付信息'),
          _buildPaymentInfoCard(context, record),
          SizedBox(height: DesignTokens.spacingLarge),

          // 房源信息
          _buildSectionTitle(context, '房源信息'),
          _buildHouseInfoCard(context, record),
          SizedBox(height: DesignTokens.spacingXLarge),

          // 操作按钮
          if (isPending) _buildActionButton(context, record),
        ],
      ),
    );
  }

  /// 构建状态卡片
  Widget _buildStatusCard(
    BuildContext context,
    PaymentRecordModel record,
    Color statusColor,
    String statusText,
    bool isSuccess,
  ) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isPending = record.status == PaymentStatus.pending;
    final dateFormatter = DateFormat('yyyy年MM月dd日 HH:mm');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DesignTokens.spacingLarge),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 状态图标
          Icon(
            isSuccess
                ? Icons.check_circle
                : isPending
                ? Icons.access_time
                : Icons.error,
            size: 60,
            color: statusColor,
          ),
          SizedBox(height: DesignTokens.spacingMedium),

          // 状态文本
          Text(
            statusText,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          SizedBox(height: DesignTokens.spacingSmall),

          // 支付金额
          Text(
            '¥${record.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.spacingMedium),

          // 支付/截止时间
          if (isPending && record.paymentTime.isAfter(now))
            Text(
              '支付截止日: ${dateFormatter.format(record.paymentTime)}',
              style: const TextStyle(color: Colors.red),
            )
          else
            Text('支付时间: ${dateFormatter.format(record.paymentTime)}'),
        ],
      ),
    );
  }

  /// 构建订单信息卡片
  Widget _buildOrderInfoCard(BuildContext context, PaymentRecordModel record) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        side: BorderSide(color: DesignTokens.borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        child: Column(
          children: [
            _buildInfoRow('订单编号', record.orderId),
            _buildDivider(),
            _buildInfoRow('订单名称', record.title),
            _buildDivider(),
            _buildInfoRow('支付类型', _getPaymentTypeText(record.type)),
            if (record.remark != null && record.remark!.isNotEmpty) ...[
              _buildDivider(),
              _buildInfoRow('备注', record.remark!),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建支付信息卡片
  Widget _buildPaymentInfoCard(
    BuildContext context,
    PaymentRecordModel record,
  ) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // 模拟支付信息
    String paymentMethod = '支付宝';
    String transactionId = 'TX${record.orderId.substring(2)}';
    String paymentAccount = '152****8976';

    if (record.status == PaymentStatus.pending) {
      return Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          side: BorderSide(color: DesignTokens.borderColor),
        ),
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spacingMedium),
          child: Column(
            children: [
              _buildInfoRow('支付状态', '待支付'),
              _buildDivider(),
              _buildInfoRow('应付金额', '¥${record.amount.toStringAsFixed(2)}'),
              _buildDivider(),
              _buildInfoRow('截止日期', dateFormatter.format(record.paymentTime)),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        side: BorderSide(color: DesignTokens.borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        child: Column(
          children: [
            _buildInfoRow('支付方式', paymentMethod),
            _buildDivider(),
            _buildInfoRow('交易号', transactionId),
            _buildDivider(),
            _buildInfoRow('支付账号', paymentAccount),
            _buildDivider(),
            _buildInfoRow('支付时间', dateFormatter.format(record.paymentTime)),
            _buildDivider(),
            _buildInfoRow('支付金额', '¥${record.amount.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  /// 构建房源信息卡片
  Widget _buildHouseInfoCard(BuildContext context, PaymentRecordModel record) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        side: BorderSide(color: DesignTokens.borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        child: Column(
          children: [
            _buildInfoRow('房源名称', record.houseName),
            _buildDivider(),
            _buildInfoRow('房源编号', record.houseId),
            _buildDivider(),
            InkWell(
              onTap: () => _navigateToHouseDetail(context, record.houseId),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '查看房源详情',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(BuildContext context, PaymentRecordModel record) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handlePayment(context, record),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          ),
        ),
        child: const Text(
          '立即支付',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// 处理支付操作
  void _handlePayment(BuildContext context, PaymentRecordModel record) {
    // 在实际项目中，这里会跳转到支付页面进行支付
    // 这里简化处理，直接显示提示信息
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('支付功能开发中...')));
  }

  /// 跳转到房源详情页
  void _navigateToHouseDetail(BuildContext context, String houseId) {
    AppRouter.navigateTo(context, AppRouter.houseDetail, arguments: houseId);
  }

  /// 构建标题
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: DesignTokens.spacingSmall,
        left: DesignTokens.spacingSmall,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeMedium,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  /// 构建分隔线
  Widget _buildDivider() {
    return Divider(
      height: DesignTokens.spacingMedium,
      thickness: 1,
      color: DesignTokens.borderColor.withOpacity(0.5),
    );
  }

  /// 根据支付状态获取颜色和文本
  (Color, String) _getStatusInfo(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return (Colors.orange, '待支付');
      case PaymentStatus.success:
        return (Colors.green, '支付成功');
      case PaymentStatus.failed:
        return (Colors.red, '支付失败');
      case PaymentStatus.canceled:
        return (Colors.grey, '已取消');
      case PaymentStatus.refunded:
        return (Colors.blue, '已退款');
    }
  }

  /// 获取支付类型文本
  String _getPaymentTypeText(PaymentType type) {
    switch (type) {
      case PaymentType.rent:
        return '租金';
      case PaymentType.deposit:
        return '押金';
      case PaymentType.serviceFee:
        return '服务费';
      case PaymentType.other:
        return '其他费用';
    }
  }
}
