import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/shared/widgets/app_bar_widget.dart';
import '../models/repair_model.dart';
import '../viewmodels/repair_form_provider.dart';
import '../viewmodels/repair_provider.dart';

/// 报修表单页面
class RepairFormScreen extends ConsumerStatefulWidget {
  const RepairFormScreen({super.key});

  @override
  ConsumerState<RepairFormScreen> createState() => _RepairFormScreenState();
}

class _RepairFormScreenState extends ConsumerState<RepairFormScreen> {
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// 初始化表单
  void _initForm() {
    // 预设一个测试房源
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final formNotifier = ref.read(repairFormProvider.notifier);
      formNotifier.setHouse('1', '朝阳区 - 望京 精装修一居室');

      // 设置默认的期望上门时间（明天下午）
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final defaultTime = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        14,
      );
      formNotifier.setExpectedTime(defaultTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(repairFormProvider);
    _descriptionController.text = formState.description;

    return Scaffold(
      appBar: const AppBarWidget(title: '报修申请', showBackButton: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child:
            _isSubmitting ? _buildLoadingView() : _buildFormContent(formState),
      ),
    );
  }

  /// 构建加载视图
  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('正在提交报修申请...'),
        ],
      ),
    );
  }

  /// 构建表单内容
  Widget _buildFormContent(RepairFormState formState) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 房源选择部分
            _buildSectionTitle('选择房源'),
            _buildHouseSelector(formState),
            SizedBox(height: DesignTokens.spacingLarge),

            // 故障类型选择
            _buildSectionTitle('故障类型'),
            _buildRepairTypeSelector(formState),
            SizedBox(height: DesignTokens.spacingLarge),

            // 问题描述
            _buildSectionTitle('问题描述'),
            _buildDescriptionInput(),
            SizedBox(height: DesignTokens.spacingLarge),

            // 上传照片
            _buildSectionTitle('上传照片'),
            _buildImageUploader(formState),
            SizedBox(height: DesignTokens.spacingLarge),

            // 期望上门时间
            _buildSectionTitle('期望上门时间'),
            _buildDateTimeSelector(formState),
            SizedBox(height: DesignTokens.spacingXLarge),

            // 提交按钮
            _buildSubmitButton(formState),
          ],
        ),
      ),
    );
  }

  /// 构建小节标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacingSmall),
      child: Text(
        title,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeMedium,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 构建房源选择器
  Widget _buildHouseSelector(RepairFormState formState) {
    return InkWell(
      onTap: _selectHouse,
      child: Container(
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          border: Border.all(color: DesignTokens.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                formState.houseName ?? '选择需要报修的房源',
                style: TextStyle(
                  color: formState.houseName != null ? null : Colors.grey[600],
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  /// 构建故障类型选择器
  Widget _buildRepairTypeSelector(RepairFormState formState) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: DesignTokens.spacingSmall,
      crossAxisSpacing: DesignTokens.spacingSmall,
      children: [
        _buildTypeItem(
          RepairType.plumbing,
          '水暖问题',
          Icons.water_damage,
          formState,
        ),
        _buildTypeItem(
          RepairType.electrical,
          '电路问题',
          Icons.electric_bolt,
          formState,
        ),
        _buildTypeItem(RepairType.lock, '门锁问题', Icons.lock, formState),
        _buildTypeItem(
          RepairType.airConditioner,
          '空调问题',
          Icons.ac_unit,
          formState,
        ),
        _buildTypeItem(RepairType.network, '网络问题', Icons.wifi, formState),
        _buildTypeItem(RepairType.other, '其他问题', Icons.build, formState),
      ],
    );
  }

  /// 构建故障类型选项
  Widget _buildTypeItem(
    RepairType type,
    String label,
    IconData icon,
    RepairFormState formState,
  ) {
    final isSelected = formState.selectedType == type;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => ref.read(repairFormProvider.notifier).setRepairType(type),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          border: Border.all(
            color: isSelected ? theme.primaryColor : DesignTokens.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.primaryColor : Colors.grey[600],
              size: 32,
            ),
            SizedBox(height: DesignTokens.spacingSmall),
            Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSmall,
                color: isSelected ? theme.primaryColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建问题描述输入框
  Widget _buildDescriptionInput() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        border: Border.all(color: DesignTokens.borderColor),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: '请详细描述您遇到的问题...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(DesignTokens.spacingMedium),
        ),
        onChanged: (value) {
          ref.read(repairFormProvider.notifier).setDescription(value);
        },
      ),
    );
  }

  /// 构建图片上传部分
  Widget _buildImageUploader(RepairFormState formState) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // 添加图片按钮
          _buildAddImageButton(),

          // 已上传的图片预览
          ...List.generate(
            formState.imageUrls.length,
            (index) => _buildImagePreview(formState.imageUrls[index], index),
          ),
        ],
      ),
    );
  }

  /// 构建添加图片按钮
  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.only(right: DesignTokens.spacingSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          border: Border.all(
            color: DesignTokens.borderColor,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: Colors.grey[600], size: 28),
            SizedBox(height: DesignTokens.spacingXSmall),
            Text(
              '添加照片',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXSmall,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建图片预览
  Widget _buildImagePreview(String imageUrl, int index) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: EdgeInsets.only(right: DesignTokens.spacingSmall),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -5,
          right: 5,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建日期时间选择器
  Widget _buildDateTimeSelector(RepairFormState formState) {
    String dateTimeText = '请选择期望上门时间';

    if (formState.expectedTime != null) {
      final dateFormatter = DateFormat('yyyy-MM-dd');
      final timeFormatter = DateFormat('HH:mm');
      final date = dateFormatter.format(formState.expectedTime!);
      final time = timeFormatter.format(formState.expectedTime!);
      dateTimeText = '$date $time';
    }

    return InkWell(
      onTap: () => _selectDateTime(formState.expectedTime),
      child: Container(
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          border: Border.all(color: DesignTokens.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dateTimeText,
                style: TextStyle(
                  color:
                      formState.expectedTime != null ? null : Colors.grey[600],
                ),
              ),
            ),
            Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  /// 构建提交按钮
  Widget _buildSubmitButton(RepairFormState formState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: formState.isValid ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          ),
        ),
        child: Text(
          '提交报修申请',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 选择房源（这里模拟只有一个房源）
  void _selectHouse() {
    // 实际项目中应该有选择房源的弹窗或页面
    // 这里简化处理，只提示用户
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已选择默认房源')));
  }

  /// 选择日期时间
  Future<void> _selectDateTime(DateTime? initialDate) async {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    // 选择日期
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? tomorrow,
      firstDate: tomorrow,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (date != null) {
      // 选择时间
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          initialDate ?? DateTime(now.year, now.month, now.day, 14, 0),
        ),
      );

      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        ref.read(repairFormProvider.notifier).setExpectedTime(dateTime);
      }
    }
  }

  /// 选择图片
  void _pickImage() {
    // 实际项目中应该调用相机或图库
    // 这里简化处理，添加一个模拟图片URL
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('图片上传功能开发中')));

    // 模拟添加图片
    ref
        .read(repairFormProvider.notifier)
        .addImage('https://via.placeholder.com/100');
  }

  /// 移除图片
  void _removeImage(int index) {
    ref.read(repairFormProvider.notifier).removeImage(index);
  }

  /// 提交表单
  Future<void> _submitForm() async {
    final formState = ref.read(repairFormProvider);

    setState(() {
      _isSubmitting = true;
    });

    try {
      // 调用报修Provider添加报修记录
      final success = await ref
          .read(repairProvider.notifier)
          .addRepairRecord(
            houseId: formState.houseId!,
            houseName: formState.houseName!,
            description: formState.description,
            type: formState.selectedType,
            expectedTime: formState.expectedTime,
            imageUrls: formState.imageUrls,
          );

      if (success) {
        // 重置表单
        ref.read(repairFormProvider.notifier).resetForm();

        // 返回上一页
        if (mounted) {
          Navigator.pop(context);

          // 显示成功提示
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('报修申请提交成功')));
        }
      } else {
        throw Exception('提交失败');
      }
    } catch (e) {
      // 显示错误提示
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('提交失败: ${e.toString()}')));

        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
