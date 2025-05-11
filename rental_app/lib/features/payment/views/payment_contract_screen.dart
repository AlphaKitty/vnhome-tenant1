import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/shared/widgets/app_bar_widget.dart';
import '../models/payment_record_model.dart';
import '../viewmodels/payment_provider.dart';

/// 支付与合同管理页面
class PaymentContractScreen extends ConsumerStatefulWidget {
  const PaymentContractScreen({super.key});

  @override
  ConsumerState<PaymentContractScreen> createState() =>
      _PaymentContractScreenState();
}

class _PaymentContractScreenState extends ConsumerState<PaymentContractScreen> {
  @override
  void initState() {
    super.initState();
    // 初始化时加载支付记录
    Future.microtask(
      () => ref.read(paymentProvider.notifier).loadPaymentRecords(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final theme = Theme.of(context);

    // 获取待支付记录
    final pendingRecords =
        paymentState.paymentRecords
            .where((record) => record.status == PaymentStatus.pending)
            .toList();

    // 获取最近3条支付记录
    final recentRecords = List<PaymentRecordModel>.from(
      paymentState.paymentRecords,
    )..sort((a, b) => b.paymentTime.compareTo(a.paymentTime));
    final displayRecords = recentRecords.take(3).toList();

    return Scaffold(
      appBar: const AppBarWidget(title: '支付与合同管理', showBackButton: true),
      body:
          paymentState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : paymentState.error != null
              ? _buildErrorView(paymentState.error!)
              : _buildContent(context, pendingRecords, displayRecords),
    );
  }

  /// 构建页面主体内容
  Widget _buildContent(
    BuildContext context,
    List<PaymentRecordModel> pendingRecords,
    List<PaymentRecordModel> recentRecords,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 待支付租金卡片
          if (pendingRecords.isNotEmpty)
            _buildPendingPaymentCard(context, pendingRecords.first),

          // 当前合同信息
          _buildContractCard(context),

          // 支付记录
          _buildPaymentRecordsSection(context, recentRecords),
        ],
      ),
    );
  }

  /// 构建待支付租金卡片
  Widget _buildPendingPaymentCard(
    BuildContext context,
    PaymentRecordModel record,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      color: theme.primaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '待缴纳租金',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeSmall,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacingXSmall),
                  Text(
                    '¥${record.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _navigateToPaymentDetail(record.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusMedium,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingMedium,
                    vertical: DesignTokens.spacingSmall,
                  ),
                ),
                child: const Text(
                  '立即支付',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacingMedium),
          Row(
            children: [
              Text(
                record.houseName,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeSmall,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(width: DesignTokens.spacingMedium),
              Text(
                '截止日期：${_formatDate(record.paymentTime)}',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeSmall,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建合同信息卡片
  Widget _buildContractCard(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '当前合同',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.spacingMedium),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
            child: Padding(
              padding: EdgeInsets.all(DesignTokens.spacingMedium),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '精装修一居室租赁合同',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToContractDetail,
                        child: Text(
                          '查看详情',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingMedium),
                  _buildContractInfoRow(Icons.location_on, '朝阳区 - 望京'),
                  SizedBox(height: DesignTokens.spacingMedium),
                  _buildContractInfoRow(
                    Icons.calendar_today,
                    '2023-01-15 至 2024-01-14',
                  ),
                  SizedBox(height: DesignTokens.spacingMedium),
                  _buildContractInfoRow(Icons.person, '房东: 王先生'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建合同信息行
  Widget _buildContractInfoRow(IconData icon, String text) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Icon(icon, color: theme.primaryColor, size: 20),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: DesignTokens.fontSizeSmall),
          ),
        ),
      ],
    );
  }

  /// 构建支付记录部分
  Widget _buildPaymentRecordsSection(
    BuildContext context,
    List<PaymentRecordModel> records,
  ) {
    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '支付记录',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: _navigateToPaymentRecords,
                child: Text(
                  '查看更多记录',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: DesignTokens.fontSizeSmall,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacingMedium),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              boxShadow: DesignTokens.shadowSmall,
            ),
            child: Column(
              children:
                  records
                      .map((record) => _buildPaymentRecordItem(record))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建支付记录项
  Widget _buildPaymentRecordItem(PaymentRecordModel record) {
    final theme = Theme.of(context);

    // 获取支付状态颜色
    final (_, statusText) = _getStatusInfo(record.status);

    return InkWell(
      onTap: () => _navigateToPaymentDetail(record.id),
      child: Container(
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: DesignTokens.borderColor, width: 1),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: DesignTokens.fontSizeMedium,
                  ),
                ),
                Text(
                  '¥${record.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: DesignTokens.fontSizeMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: DesignTokens.spacingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '支付方式: ${_getPaymentMethod(record)}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSmall,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  _formatDate(record.paymentTime),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSmall,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建错误视图
  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          SizedBox(height: DesignTokens.spacingMedium),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.spacingSmall),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSmall,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: DesignTokens.spacingMedium),
          ElevatedButton(
            onPressed:
                () => ref.read(paymentProvider.notifier).loadPaymentRecords(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 获取支付方式文本
  String _getPaymentMethod(PaymentRecordModel record) {
    if (record.status == PaymentStatus.pending) return '待支付';
    return '支付宝'; // 模拟数据
  }

  /// 根据支付状态获取颜色和文本
  (Color, String) _getStatusInfo(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return (Colors.orange, '待支付');
      case PaymentStatus.success:
        return (Colors.green, '已支付');
      case PaymentStatus.failed:
        return (Colors.red, '支付失败');
      case PaymentStatus.canceled:
        return (Colors.grey, '已取消');
      case PaymentStatus.refunded:
        return (Colors.blue, '已退款');
    }
  }

  /// 格式化日期
  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  /// 跳转到支付记录页面
  void _navigateToPaymentRecords() {
    AppRouter.navigateTo(context, AppRouter.payment);
  }

  /// 跳转到支付详情页面
  void _navigateToPaymentDetail(String paymentId) {
    AppRouter.navigateTo(
      context,
      AppRouter.paymentDetail,
      arguments: paymentId,
    );
  }

  /// 跳转到合同详情页面
  void _navigateToContractDetail() {
    print('跳转到合同详情页面');
    AppRouter.navigateTo(context, AppRouter.contractDetail);
  }
}
