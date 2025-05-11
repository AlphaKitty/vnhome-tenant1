import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';

/// 意见反馈页面
class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _feedbackController = TextEditingController();
  final _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _selectedType = 0;
  final List<String> _feedbackTypes = ['功能建议', '问题反馈', '投诉', '其他'];

  @override
  void dispose() {
    _feedbackController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('意见反馈'), elevation: 0),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(DesignTokens.spacingMedium),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 顶部提示
                      Container(
                        padding: EdgeInsets.all(DesignTokens.spacingMedium),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusMedium,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue),
                            SizedBox(width: DesignTokens.spacingSmall),
                            Expanded(
                              child: Text(
                                '您的反馈对我们很重要，我们将认真处理每一条反馈信息',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: DesignTokens.fontSizeSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingLarge),

                      // 反馈类型
                      Text(
                        '反馈类型',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: DesignTokens.fontSizeMedium,
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingSmall),
                      Wrap(
                        spacing: DesignTokens.spacingSmall,
                        children: List.generate(
                          _feedbackTypes.length,
                          (index) => ChoiceChip(
                            label: Text(_feedbackTypes[index]),
                            selected: _selectedType == index,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedType = index;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingLarge),

                      // 反馈内容
                      Text(
                        '反馈内容',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: DesignTokens.fontSizeMedium,
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingSmall),
                      TextFormField(
                        controller: _feedbackController,
                        decoration: InputDecoration(
                          hintText: '请详细描述您的问题或建议...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusMedium,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.05),
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入反馈内容';
                          }
                          if (value.length < 10) {
                            return '反馈内容至少10个字符';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: DesignTokens.spacingLarge),

                      // 联系方式
                      Text(
                        '联系方式 (选填)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: DesignTokens.fontSizeMedium,
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingSmall),
                      TextFormField(
                        controller: _contactController,
                        decoration: InputDecoration(
                          hintText: '留下您的手机号或邮箱，方便我们联系您',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusMedium,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.05),
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingXLarge),

                      // 提交按钮
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(DesignTokens.spacingMedium),
                          ),
                          child: const Text('提交反馈'),
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingMedium),

                      // 底部提示
                      Center(
                        child: Text(
                          '感谢您的反馈，我们会尽快处理',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeXSmall,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  /// 提交反馈
  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // 模拟API调用
        await Future.delayed(const Duration(seconds: 1));

        // TODO: 实现实际的反馈提交逻辑

        if (mounted) {
          // 显示成功提示
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('反馈提交成功，感谢您的宝贵意见')));

          // 返回上一页
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('提交失败: ${e.toString()}')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
