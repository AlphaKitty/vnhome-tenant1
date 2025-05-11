/// 房源实体模型
class HouseModel {
  final String id;
  final String title;
  final String location;
  final String district;
  final String? description;
  final double price;
  final String roomType;
  final double area;
  final String floor;
  final String direction;
  final List<String> imageUrls;
  final List<String> tags;

  HouseModel({
    required this.id,
    required this.title,
    required this.location,
    required this.district,
    this.description,
    required this.price,
    required this.roomType,
    required this.area,
    required this.floor,
    required this.direction,
    this.imageUrls = const [],
    this.tags = const [],
  });

  /// 从JSON映射创建房源模型
  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      district: json['district'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      roomType: json['roomType'] as String,
      area: (json['area'] as num).toDouble(),
      floor: json['floor'] as String,
      direction: json['direction'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
    );
  }

  /// 转换为JSON映射
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'district': district,
      'description': description,
      'price': price,
      'roomType': roomType,
      'area': area,
      'floor': floor,
      'direction': direction,
      'imageUrls': imageUrls,
      'tags': tags,
    };
  }

  /// 创建房源模型的副本
  HouseModel copyWith({
    String? id,
    String? title,
    String? location,
    String? district,
    String? description,
    double? price,
    String? roomType,
    double? area,
    String? floor,
    String? direction,
    List<String>? imageUrls,
    List<String>? tags,
  }) {
    return HouseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      district: district ?? this.district,
      description: description ?? this.description,
      price: price ?? this.price,
      roomType: roomType ?? this.roomType,
      area: area ?? this.area,
      floor: floor ?? this.floor,
      direction: direction ?? this.direction,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
    );
  }
}
