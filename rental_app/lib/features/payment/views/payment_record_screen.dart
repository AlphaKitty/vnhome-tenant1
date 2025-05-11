import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/shared/widgets/app_bar_widget.dart';
import '../models/payment_record_model.dart';
import '../viewmodels/payment_provider.dart';

/// 支付记录页面
class PaymentRecordScreen extends ConsumerStatefulWidget {
  const PaymentRecordScreen({super.key});

  @override
  ConsumerState<PaymentRecordScreen> createState() =>
      _PaymentRecordScreenState();
}

class _PaymentRecordScreenState extends ConsumerState<PaymentRecordScreen> {
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

    return Scaffold(
      appBar: const AppBarWidget(title: '支付记录', showBackButton: true),
      body: Column(
        children: [
          // 标签按钮区域
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingMedium),
            child: Row(
              children: [
                _buildTabButton(
                  context,
                  PaymentTabOption.all,
                  '全部',
                  paymentState.selectedTab,
                ),
                SizedBox(width: DesignTokens.spacingMedium),
                _buildTabButton(
                  context,
                  PaymentTabOption.pending,
                  '待付款',
                  paymentState.selectedTab,
                ),
                SizedBox(width: DesignTokens.spacingMedium),
                _buildTabButton(
                  context,
                  PaymentTabOption.completed,
                  '已完成',
                  paymentState.selectedTab,
                ),
              ],
            ),
          ),

          // 列表区域
          Expanded(
            child:
                paymentState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : paymentState.error != null
                    ? _buildErrorView(paymentState.error!)
                    : paymentState.filteredRecords.isEmpty
                    ? _buildEmptyView('暂无支付记录')
                    : _buildRecordsList(paymentState.filteredRecords),
          ),
        ],
      ),
    );
  }

  /// 构建标签按钮
  Widget _buildTabButton(
    BuildContext context,
    PaymentTabOption tabOption,
    String title,
    PaymentTabOption selectedTab,
  ) {
    final theme = Theme.of(context);
    final isSelected = selectedTab == tabOption;

    return Expanded(
      child: ElevatedButton(
        onPressed:
            () => ref.read(paymentProvider.notifier).selectTab(tabOption),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? theme.primaryColor : theme.cardColor,
          foregroundColor:
              isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
            side: BorderSide(
              color: isSelected ? Colors.transparent : theme.dividerColor,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingSmall),
        ),
        child: Text(title),
      ),
    );
  }

  /// 构建记录列表
  Widget _buildRecordsList(List<PaymentRecordModel> records) {
    // 按时间排序记录
    final sortedRecords = List<PaymentRecordModel>.from(records)
      ..sort((a, b) => b.paymentTime.compareTo(a.paymentTime));

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingMedium),
      itemCount: sortedRecords.length,
      separatorBuilder:
          (context, index) => Divider(
            height: 1,
            indent: DesignTokens.spacingLarge,
            endIndent: DesignTokens.spacingLarge,
          ),
      itemBuilder: (context, index) {
        final record = sortedRecords[index];
        return _buildRecordItem(record);
      },
    );
  }

  /// 构建单个记录项
  Widget _buildRecordItem(PaymentRecordModel record) {
    final theme = Theme.of(context);

    // 格式化日期
    final dateStr = _formatDate(record.paymentTime);

    // 根据支付状态设置颜色和标签文本
    final (statusColor, statusText) = _getStatusInfo(record.status);

    // 根据支付类型设置图标
    final typeIcon = _getTypeIcon(record.type);

    return InkWell(
      onTap: () {
        // 跳转到支付详情页
        AppRouter.navigateTo(
          context,
          AppRouter.paymentDetail,
          arguments: record.id,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLarge,
          vertical: DesignTokens.spacingMedium,
        ),
        child: Row(
          children: [
            // 类型图标
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
              ),
              child: Icon(typeIcon, color: theme.primaryColor),
            ),
            SizedBox(width: DesignTokens.spacingMedium),

            // 记录信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          record.title,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMedium,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '¥${record.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                          color:
                              record.status == PaymentStatus.refunded
                                  ? Colors.green
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingXSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 房源名称
                      Expanded(
                        child: Text(
                          record.houseName,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSmall,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 状态标签
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingXSmall,
                          vertical: DesignTokens.spacingXXSmall,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusSmall,
                          ),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeXSmall,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingXSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 订单编号
                      Text(
                        '订单号：${record.orderId}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeXSmall,
                          color: Colors.grey[600],
                        ),
                      ),
                      // 日期
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeXSmall,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  // 如果有备注则显示
                  if (record.remark != null && record.remark!.isNotEmpty) ...[
                    SizedBox(height: DesignTokens.spacingXSmall),
                    Text(
                      '备注：${record.remark}',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXSmall,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  /// 根据支付类型获取图标
  IconData _getTypeIcon(PaymentType type) {
    switch (type) {
      case PaymentType.rent:
        return Icons.home;
      case PaymentType.deposit:
        return Icons.account_balance_wallet;
      case PaymentType.serviceFee:
        return Icons.build;
      case PaymentType.other:
        return Icons.attach_money;
    }
  }

  /// 格式化日期
  String _formatDate(DateTime dateTime) {
    // 检查是否是未来日期（待支付）
    final now = DateTime.now();
    if (dateTime.isAfter(now)) {
      return '待支付: ${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }

    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  /// 构建空记录视图
  Widget _buildEmptyView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          SizedBox(height: DesignTokens.spacingMedium),
          Text(
            message,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMedium,
              color: Colors.grey[600],
            ),
          ),
        ],
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
}
