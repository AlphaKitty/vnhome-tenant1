import 'package:flutter/material.dart';

/// 客服项目模型
class SupportItemModel {
  final String id;
  final String title;
  final String? description;
  final IconData icon;
  final String? route;
  final Function? onTap;

  SupportItemModel({
    required this.id,
    required this.title,
    this.description,
    required this.icon,
    this.route,
    this.onTap,
  });
}

/// 常见问题模型
class FaqItemModel {
  final String id;
  final String question;
  final String answer;
  final bool isExpanded;

  FaqItemModel({
    required this.id,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  FaqItemModel copyWith({bool? isExpanded}) {
    return FaqItemModel(
      id: id,
      question: question,
      answer: answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

/// 客服联系方式模型
class ContactMethodModel {
  final String id;
  final String title;
  final String value;
  final IconData icon;
  final Function? onTap;

  ContactMethodModel({
    required this.id,
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
  });
}
