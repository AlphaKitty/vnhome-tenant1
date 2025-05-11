import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/repair_model.dart';

/// 报修表单状态
class RepairFormState {
  final String? houseId;
  final String? houseName;
  final String description;
  final RepairType selectedType;
  final DateTime? expectedTime;
  final List<String> imageUrls;
  final bool isSubmitting;
  final String? error;

  const RepairFormState({
    this.houseId,
    this.houseName,
    this.description = '',
    this.selectedType = RepairType.plumbing,
    this.expectedTime,
    this.imageUrls = const [],
    this.isSubmitting = false,
    this.error,
  });

  /// 检查表单是否有效
  bool get isValid =>
      houseId != null &&
      houseName != null &&
      description.isNotEmpty &&
      expectedTime != null;

  /// 创建一个表单状态副本
  RepairFormState copyWith({
    String? houseId,
    String? houseName,
    String? description,
    RepairType? selectedType,
    DateTime? expectedTime,
    List<String>? imageUrls,
    bool? isSubmitting,
    String? error,
  }) {
    return RepairFormState(
      houseId: houseId ?? this.houseId,
      houseName: houseName ?? this.houseName,
      description: description ?? this.description,
      selectedType: selectedType ?? this.selectedType,
      expectedTime: expectedTime ?? this.expectedTime,
      imageUrls: imageUrls ?? this.imageUrls,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  /// 重置表单状态
  RepairFormState reset() {
    return const RepairFormState();
  }
}

/// 报修表单状态提供者
class RepairFormNotifier extends StateNotifier<RepairFormState> {
  RepairFormNotifier() : super(const RepairFormState());

  /// 设置房源信息
  void setHouse(String houseId, String houseName) {
    state = state.copyWith(houseId: houseId, houseName: houseName, error: null);
  }

  /// 设置问题描述
  void setDescription(String description) {
    state = state.copyWith(description: description, error: null);
  }

  /// 设置报修类型
  void setRepairType(RepairType type) {
    state = state.copyWith(selectedType: type, error: null);
  }

  /// 设置期望上门时间
  void setExpectedTime(DateTime time) {
    state = state.copyWith(expectedTime: time, error: null);
  }

  /// 添加图片
  void addImage(String imageUrl) {
    final updatedImages = [...state.imageUrls, imageUrl];
    state = state.copyWith(imageUrls: updatedImages, error: null);
  }

  /// 移除图片
  void removeImage(int index) {
    if (index >= 0 && index < state.imageUrls.length) {
      final updatedImages = List<String>.from(state.imageUrls);
      updatedImages.removeAt(index);
      state = state.copyWith(imageUrls: updatedImages, error: null);
    }
  }

  /// 设置提交状态
  void setSubmitting(bool isSubmitting) {
    state = state.copyWith(isSubmitting: isSubmitting, error: null);
  }

  /// 设置错误信息
  void setError(String error) {
    state = state.copyWith(error: error, isSubmitting: false);
  }

  /// 重置表单
  void resetForm() {
    state = state.reset();
  }
}

/// 报修表单状态提供者
final repairFormProvider =
    StateNotifierProvider<RepairFormNotifier, RepairFormState>((ref) {
      return RepairFormNotifier();
    });
