import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/features/auth/viewmodels/auth_provider.dart';

/// 个人资料编辑页面
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _usernameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _addressController =
        TextEditingController(); // 初始化为空字符串，假设UserModel中没有address属性
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('修改个人资料'), elevation: 0),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(DesignTokens.spacingLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 头像编辑
                      Center(
                        child: Stack(
                          children: [
                            // 头像
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              backgroundImage:
                                  ref.watch(authProvider).user?.avatar != null
                                      ? NetworkImage(
                                        ref.watch(authProvider).user!.avatar!,
                                      )
                                      : null,
                              child:
                                  ref.watch(authProvider).user?.avatar == null
                                      ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                      : null,
                            ),

                            // 编辑按钮
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingXLarge),

                      // 用户名
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: '用户名',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入用户名';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: DesignTokens.spacingLarge),

                      // 电子邮箱
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: '电子邮箱',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入电子邮箱';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return '请输入有效的电子邮箱';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: DesignTokens.spacingLarge),

                      // 手机号码
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: '手机号码',
                          prefixIcon: Icon(Icons.phone_android),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入手机号码';
                          }
                          if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                            return '请输入有效的手机号码';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: DesignTokens.spacingLarge),

                      // 地址
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: '联系地址',
                          prefixIcon: Icon(Icons.home),
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: DesignTokens.spacingXLarge),

                      // 提交按钮
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(DesignTokens.spacingMedium),
                          ),
                          child: const Text('保存修改'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  /// 提交表单
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // 模拟API调用
        await Future.delayed(const Duration(seconds: 1));

        // TODO: 实现实际的个人资料更新逻辑

        if (mounted) {
          // 显示成功提示
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('个人资料更新成功')));

          // 返回上一页
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('更新失败: ${e.toString()}')));
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
