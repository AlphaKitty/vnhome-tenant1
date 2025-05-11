import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/shared/widgets/app_bar_widget.dart';
import '../models/contract_model.dart';
import '../viewmodels/contract_provider.dart';

/// 合同详情页面
class ContractDetailScreen extends ConsumerStatefulWidget {
  const ContractDetailScreen({super.key});

  @override
  ConsumerState<ContractDetailScreen> createState() =>
      _ContractDetailScreenState();
}

class _ContractDetailScreenState extends ConsumerState<ContractDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 初始化时加载合同数据
    Future.microtask(
      () => ref.read(contractProvider.notifier).loadCurrentContract(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contractState = ref.watch(contractProvider);

    return Scaffold(
      appBar: AppBarWidget(
        title: '合同详情',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _downloadContract,
          ),
        ],
      ),
      body:
          contractState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : contractState.error != null
              ? _buildErrorView(contractState.error!)
              : contractState.contract != null
              ? _buildContractDetail(contractState.contract!)
              : const Center(child: Text('未找到合同')),
    );
  }

  /// 构建合同详情内容
  Widget _buildContractDetail(ContractModel contract) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd');

    return SingleChildScrollView(
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 合同标题
              Center(
                child: Text(
                  '房屋租赁合同',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
              ),
              SizedBox(height: DesignTokens.spacingXLarge),

              // 出租方信息
              _buildSectionTitle('甲方（出租方）', Icons.person, theme.primaryColor),
              SizedBox(height: DesignTokens.spacingSmall),
              Text('${contract.landlordName}，身份证号：${contract.landlordIdCard}'),
              Text('联系电话：${contract.landlordPhone}'),
              SizedBox(height: DesignTokens.spacingLarge),

              // 承租方信息
              _buildSectionTitle(
                '乙方（承租方）',
                Icons.person_outline,
                theme.primaryColor,
              ),
              SizedBox(height: DesignTokens.spacingSmall),
              Text('${contract.tenantName}，身份证号：${contract.tenantIdCard}'),
              Text('联系电话：${contract.tenantPhone}'),
              SizedBox(height: DesignTokens.spacingLarge),

              // 房屋基本情况
              _buildSectionTitle('房屋基本情况', Icons.home, theme.primaryColor),
              SizedBox(height: DesignTokens.spacingSmall),
              Text('座落于：${contract.houseAddress}，建筑面积55平方米'),
              SizedBox(height: DesignTokens.spacingLarge),

              // 租赁期限
              _buildSectionTitle('租赁期限', Icons.date_range, theme.primaryColor),
              SizedBox(height: DesignTokens.spacingSmall),
              Text(
                '自${dateFormat.format(contract.startDate)}起至${dateFormat.format(contract.endDate)}止，共计12个月',
              ),
              SizedBox(height: DesignTokens.spacingLarge),

              // 租金及支付方式
              _buildSectionTitle('租金及支付方式', Icons.payment, theme.primaryColor),
              SizedBox(height: DesignTokens.spacingSmall),
              Text('月租金为人民币${contract.rentPrice.toStringAsFixed(0)}元整'),
              Text(
                '支付方式：${contract.paymentCycle}，乙方应于每月${contract.paymentDay}日前支付当月租金',
              ),
              SizedBox(height: DesignTokens.spacingLarge),

              // 押金
              _buildSectionTitle(
                '押金',
                Icons.account_balance_wallet,
                theme.primaryColor,
              ),
              SizedBox(height: DesignTokens.spacingSmall),
              Text(
                '乙方应于签订合同时支付押金${contract.depositPrice.toStringAsFixed(0)}元，合同期满，房屋验收合格后，甲方应将押金无息退还乙方',
              ),
              SizedBox(height: DesignTokens.spacingLarge),

              // 合同条款
              _buildSectionTitle('合同条款', Icons.gavel, theme.primaryColor),
              SizedBox(height: DesignTokens.spacingSmall),
              ...contract.terms.map(
                (term) => Padding(
                  padding: EdgeInsets.only(bottom: DesignTokens.spacingMedium),
                  child: Text(term),
                ),
              ),

              // 签署日期
              SizedBox(height: DesignTokens.spacingXLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '甲方签字',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: DesignTokens.spacingMedium),
                      Text(contract.landlordName),
                      SizedBox(height: DesignTokens.spacingSmall),
                      Text(dateFormat.format(contract.signDate)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '乙方签字',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: DesignTokens.spacingMedium),
                      Text(contract.tenantName),
                      SizedBox(height: DesignTokens.spacingSmall),
                      Text(dateFormat.format(contract.signDate)),
                    ],
                  ),
                ],
              ),

              // 备注
              if (contract.remark != null) ...[
                SizedBox(height: DesignTokens.spacingXLarge),
                Center(
                  child: Text(
                    contract.remark!,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: DesignTokens.fontSizeSmall,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建小节标题
  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: DesignTokens.spacingSmall),
        Text(
          title,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
                () => ref.read(contractProvider.notifier).loadCurrentContract(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 下载合同
  void _downloadContract() {
    // 实际应用中应该实现下载功能，这里为示例
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('合同下载功能开发中...')));
  }
}
