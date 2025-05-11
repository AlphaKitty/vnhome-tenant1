import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/shared/widgets/app_bar_widget.dart';
import '../models/repair_model.dart';
import '../viewmodels/repair_provider.dart';
import '../viewmodels/repair_form_provider.dart';
import 'repair_form_screen.dart';

/// 报修服务页面
class RepairServiceScreen extends ConsumerStatefulWidget {
  const RepairServiceScreen({super.key});

  @override
  ConsumerState<RepairServiceScreen> createState() =>
      _RepairServiceScreenState();
}

class _RepairServiceScreenState extends ConsumerState<RepairServiceScreen> {
  @override
  void initState() {
    super.initState();
    // 初始化时加载报修记录
    Future.microtask(
      () => ref.read(repairProvider.notifier).loadRepairRecords(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repairState = ref.watch(repairProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppBarWidget(title: '报修服务', showBackButton: true),
      body: Column(
        children: [
          // 创建报修按钮区域
          _buildCreateRepairButton(context),

          // 历史记录标题
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '历史报修记录',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // 筛选下拉菜单
                _buildFilterDropdown(),
              ],
            ),
          ),

          // 列表区域
          Expanded(
            child:
                repairState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : repairState.error != null
                    ? _buildErrorView(repairState.error!)
                    : repairState.filteredRecords.isEmpty
                    ? _buildEmptyView('暂无报修记录')
                    : _buildRepairList(repairState.filteredRecords),
          ),
        ],
      ),
    );
  }

  /// 构建创建报修按钮
  Widget _buildCreateRepairButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToRepairForm(),
      child: Container(
        margin: EdgeInsets.all(DesignTokens.spacingMedium),
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          boxShadow: DesignTokens.shadowSmall,
        ),
        child: Row(
          children: [
            Icon(Icons.build_rounded, color: Colors.white, size: 24),
            SizedBox(width: DesignTokens.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '创建新的报修申请',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacingXSmall),
                  Text(
                    '提交故障信息，我们将尽快安排维修',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeSmall,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  /// 构建筛选下拉菜单
  Widget _buildFilterDropdown() {
    final repairState = ref.watch(repairProvider);

    return DropdownButton<RepairStatus?>(
      value: repairState.filterStatus,
      underline: const SizedBox(),
      icon: const Icon(Icons.filter_list),
      hint: const Text('全部'),
      onChanged: (RepairStatus? newValue) {
        ref.read(repairProvider.notifier).setFilterStatus(newValue);
      },
      items: [
        const DropdownMenuItem<RepairStatus?>(value: null, child: Text('全部')),
        ...RepairStatus.values.map((RepairStatus status) {
          return DropdownMenuItem<RepairStatus>(
            value: status,
            child: Text(_getStatusText(status)),
          );
        }).toList(),
      ],
    );
  }

  /// 构建报修记录列表
  Widget _buildRepairList(List<RepairModel> records) {
    // 按时间排序记录，最新的在前面
    final sortedRecords = List<RepairModel>.from(records)
      ..sort((a, b) => b.submitTime.compareTo(a.submitTime));

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingMedium),
      itemCount: sortedRecords.length,
      separatorBuilder:
          (context, index) => SizedBox(height: DesignTokens.spacingMedium),
      itemBuilder: (context, index) {
        final record = sortedRecords[index];
        return _buildRepairCard(record);
      },
    );
  }

  /// 构建单个报修卡片
  Widget _buildRepairCard(RepairModel repair) {
    final theme = Theme.of(context);
    final (statusColor, statusText) = _getStatusInfo(repair.status);
    final typeIcon = _getTypeIcon(repair.type);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和状态
          Container(
            padding: EdgeInsets.all(DesignTokens.spacingMedium),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: DesignTokens.circularRadiusMedium,
                topRight: DesignTokens.circularRadiusMedium,
              ),
            ),
            child: Row(
              children: [
                Icon(typeIcon, color: theme.primaryColor),
                SizedBox(width: DesignTokens.spacingSmall),
                Expanded(
                  child: Text(
                    _getTypeText(repair.type),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSmall,
                    vertical: DesignTokens.spacingXXSmall,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusSmall,
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXSmall,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 内容
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 房源信息
                Row(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: DesignTokens.spacingXSmall),
                    Expanded(
                      child: Text(
                        repair.houseName,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSmall,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: DesignTokens.spacingSmall),

                // 问题描述
                Text(
                  repair.description,
                  style: TextStyle(fontSize: DesignTokens.fontSizeSmall),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: DesignTokens.spacingSmall),

                // 时间信息
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '提交时间：${_formatDate(repair.submitTime)}',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXSmall,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (repair.expectedTime != null)
                      Text(
                        '预约时间：${_formatDate(repair.expectedTime!)}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeXSmall,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),

                // 备注信息（如果有）
                if (repair.remark != null && repair.remark!.isNotEmpty) ...[
                  SizedBox(height: DesignTokens.spacingSmall),
                  Text(
                    '备注：${repair.remark}',
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
    );
  }

  /// 根据报修状态获取颜色和文本
  (Color, String) _getStatusInfo(RepairStatus status) {
    switch (status) {
      case RepairStatus.pending:
        return (Colors.orange, '待处理');
      case RepairStatus.processing:
        return (Colors.blue, '处理中');
      case RepairStatus.completed:
        return (Colors.green, '已完成');
      case RepairStatus.cancelled:
        return (Colors.grey, '已取消');
    }
  }

  /// 获取状态文本
  String _getStatusText(RepairStatus status) {
    final (_, text) = _getStatusInfo(status);
    return text;
  }

  /// 根据报修类型获取图标
  IconData _getTypeIcon(RepairType type) {
    switch (type) {
      case RepairType.plumbing:
        return Icons.water_damage;
      case RepairType.electrical:
        return Icons.electric_bolt;
      case RepairType.lock:
        return Icons.lock;
      case RepairType.airConditioner:
        return Icons.ac_unit;
      case RepairType.network:
        return Icons.wifi;
      case RepairType.other:
        return Icons.build;
    }
  }

  /// 获取类型文本
  String _getTypeText(RepairType type) {
    switch (type) {
      case RepairType.plumbing:
        return '水暖问题';
      case RepairType.electrical:
        return '电路问题';
      case RepairType.lock:
        return '门锁问题';
      case RepairType.airConditioner:
        return '空调问题';
      case RepairType.network:
        return '网络问题';
      case RepairType.other:
        return '其他问题';
    }
  }

  /// 格式化日期
  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  /// 构建空视图
  Widget _buildEmptyView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build_circle_outlined, size: 80, color: Colors.grey[400]),
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
                () => ref.read(repairProvider.notifier).loadRepairRecords(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 导航到报修表单页面
  void _navigateToRepairForm() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const RepairFormScreen()));
  }
}
