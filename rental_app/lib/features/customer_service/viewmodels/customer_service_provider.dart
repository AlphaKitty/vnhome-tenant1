import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/routes/app_router.dart';
import '../models/support_item_model.dart';

/// 客服中心状态
class CustomerServiceState {
  final List<SupportItemModel> supportItems;
  final List<FaqItemModel> faqItems;
  final List<ContactMethodModel> contactMethods;
  final bool isLoading;
  final String? error;

  CustomerServiceState({
    this.supportItems = const [],
    this.faqItems = const [],
    this.contactMethods = const [],
    this.isLoading = false,
    this.error,
  });

  /// 创建加载状态
  CustomerServiceState copyWithLoading() {
    return CustomerServiceState(
      supportItems: supportItems,
      faqItems: faqItems,
      contactMethods: contactMethods,
      isLoading: true,
      error: null,
    );
  }

  /// 创建加载完成状态
  CustomerServiceState copyWithData({
    List<SupportItemModel>? supportItems,
    List<FaqItemModel>? faqItems,
    List<ContactMethodModel>? contactMethods,
  }) {
    return CustomerServiceState(
      supportItems: supportItems ?? this.supportItems,
      faqItems: faqItems ?? this.faqItems,
      contactMethods: contactMethods ?? this.contactMethods,
      isLoading: false,
      error: null,
    );
  }

  /// 创建错误状态
  CustomerServiceState copyWithError(String errorMessage) {
    return CustomerServiceState(
      supportItems: supportItems,
      faqItems: faqItems,
      contactMethods: contactMethods,
      isLoading: false,
      error: errorMessage,
    );
  }

  /// 更新FAQ项的展开状态
  CustomerServiceState copyWithFaqExpansion(String faqId, bool isExpanded) {
    final updatedFaqItems =
        faqItems.map((item) {
          if (item.id == faqId) {
            return item.copyWith(isExpanded: isExpanded);
          }
          return item;
        }).toList();

    return CustomerServiceState(
      supportItems: supportItems,
      faqItems: updatedFaqItems,
      contactMethods: contactMethods,
      isLoading: false,
      error: error,
    );
  }
}

/// 客服中心状态管理器
class CustomerServiceNotifier extends StateNotifier<CustomerServiceState> {
  CustomerServiceNotifier() : super(CustomerServiceState()) {
    // 初始化时加载数据
    loadData();
  }

  /// 加载客服中心数据
  Future<void> loadData() async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求加载数据
      await Future.delayed(const Duration(milliseconds: 500));

      // 获取支持项目
      final supportItems = _getSupportItems();

      // 获取常见问题
      final faqItems = _getFaqItems();

      // 获取联系方式
      final contactMethods = _getContactMethods();

      state = state.copyWithData(
        supportItems: supportItems,
        faqItems: faqItems,
        contactMethods: contactMethods,
      );
    } catch (e) {
      state = state.copyWithError('加载数据失败: ${e.toString()}');
    }
  }

  /// 获取支持项目
  List<SupportItemModel> _getSupportItems() {
    return [
      SupportItemModel(
        id: 'contact',
        title: '联系客服',
        description: '有任何问题，随时联系我们的在线客服',
        icon: Icons.support_agent,
        route: AppRouter.contactSupport,
      ),
      SupportItemModel(
        id: 'faq',
        title: '常见问题',
        description: '查看常见问题的解答',
        icon: Icons.question_answer,
        route: AppRouter.faq,
      ),
      SupportItemModel(
        id: 'feedback',
        title: '意见反馈',
        description: '帮助我们改进产品和服务',
        icon: Icons.rate_review,
        route: AppRouter.feedback,
      ),
    ];
  }

  /// 获取常见问题
  List<FaqItemModel> _getFaqItems() {
    return [
      FaqItemModel(
        id: 'faq1',
        question: '如何预约看房？',
        answer: '您可以在房源详情页面点击"预约看房"按钮，选择合适的时间，填写个人信息后提交预约申请。我们的工作人员会尽快与您联系确认。',
      ),
      FaqItemModel(
        id: 'faq2',
        question: '如何支付房租？',
        answer:
            '我们支持多种支付方式，包括银行转账、支付宝、微信支付等。您可以在"我的"-"支付记录"中查看待支付的账单，并选择合适的支付方式进行支付。',
      ),
      FaqItemModel(
        id: 'faq3',
        question: '如何提交报修申请？',
        answer:
            '您可以在"我的"-"报修服务"中创建新的报修工单，填写详细的问题描述和上传相关照片，提交后我们的维修人员会尽快与您联系处理。',
      ),
      FaqItemModel(
        id: 'faq4',
        question: '租约到期怎么续约？',
        answer:
            '租约到期前一个月，系统会自动提醒您续约事宜。您可以在"我的"-"合同管理"中查看当前合同，并点击"申请续约"按钮进行续约操作。',
      ),
      FaqItemModel(
        id: 'faq5',
        question: '如何取消预约看房？',
        answer:
            '您可以在"我的"-"看房预约"中找到相应的预约记录，点击"取消预约"按钮。请注意，为了不影响我们的服务安排，建议您至少提前24小时取消预约。',
      ),
    ];
  }

  /// 获取联系方式
  List<ContactMethodModel> _getContactMethods() {
    return [
      ContactMethodModel(
        id: 'hotline',
        title: '客服热线',
        value: '400-888-8888',
        icon: Icons.phone,
        onTap: () {
          // TODO: 实现拨打电话功能
        },
      ),
      ContactMethodModel(
        id: 'email',
        title: '客服邮箱',
        value: 'support@rentalapp.com',
        icon: Icons.email,
        onTap: () {
          // TODO: 实现发送邮件功能
        },
      ),
      ContactMethodModel(
        id: 'wechat',
        title: '微信公众号',
        value: 'RentalApp租房',
        icon: Icons.chat,
        onTap: () {
          // TODO: 实现复制微信号功能
        },
      ),
    ];
  }

  /// 切换FAQ的展开状态
  void toggleFaqExpansion(String faqId, bool isExpanded) {
    state = state.copyWithFaqExpansion(faqId, isExpanded);
  }
}

/// 客服中心状态提供者
final customerServiceProvider =
    StateNotifierProvider<CustomerServiceNotifier, CustomerServiceState>(
      (ref) => CustomerServiceNotifier(),
    );
