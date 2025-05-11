/// 搜索筛选条件模型
class SearchFilterModel {
  final String? area;
  final PriceRange? priceRange;
  final String? houseType;
  final List<String> tags;
  final String? keyword;

  const SearchFilterModel({
    this.area,
    this.priceRange,
    this.houseType,
    this.tags = const [],
    this.keyword,
  });

  /// 创建筛选条件副本
  SearchFilterModel copyWith({
    String? area,
    PriceRange? priceRange,
    String? houseType,
    List<String>? tags,
    String? keyword,
  }) {
    return SearchFilterModel(
      area: area ?? this.area,
      priceRange: priceRange ?? this.priceRange,
      houseType: houseType ?? this.houseType,
      tags: tags ?? this.tags,
      keyword: keyword ?? this.keyword,
    );
  }

  /// 转换为查询参数映射
  Map<String, String> toQueryParams() {
    final params = <String, String>{};

    if (area != null && area!.isNotEmpty) {
      params['area'] = area!;
    }

    if (priceRange != null) {
      if (priceRange!.min != null) {
        params['priceMin'] = priceRange!.min.toString();
      }
      if (priceRange!.max != null) {
        params['priceMax'] = priceRange!.max.toString();
      }
    }

    if (houseType != null && houseType!.isNotEmpty) {
      params['houseType'] = houseType!;
    }

    if (tags.isNotEmpty) {
      params['tags'] = tags.join(',');
    }

    if (keyword != null && keyword!.isNotEmpty) {
      params['keyword'] = keyword!;
    }

    return params;
  }

  /// 清除所有筛选条件
  SearchFilterModel clear() {
    return const SearchFilterModel();
  }
}

/// 价格范围模型
class PriceRange {
  final int? min;
  final int? max;

  const PriceRange({this.min, this.max});

  /// 创建价格范围副本
  PriceRange copyWith({int? min, int? max}) {
    return PriceRange(min: min ?? this.min, max: max ?? this.max);
  }

  @override
  String toString() {
    if (min != null && max != null) {
      return '$min-$max元';
    } else if (min != null) {
      return '$min元以上';
    } else if (max != null) {
      return '$max元以下';
    } else {
      return '不限';
    }
  }
}
