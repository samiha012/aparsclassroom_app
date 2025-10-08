import '../../../domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productFullName,
    required super.productImage,
    required super.category,
    required super.subCategory,
    required super.platform,
    required super.currencyAmount,
    required super.permalink,
    super.fbLink,
    super.webapp,
    required super.status,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
  return CourseModel(
    id: json['_id']?.toString() ?? '',
    productId: json['productId']?.toString() ?? '',
    productName: json['productName'] ?? '',
    productFullName: json['productFullName'] ?? '',
    productImage: json['ProductImage'] ?? '',
    category: json['Category'] ?? '',
    subCategory: json['SubCategory'] ?? '', // fixed casing
    platform: json['Platform'] ?? '',       // fixed casing
    currencyAmount:
        double.tryParse(json['currency_amount']?.toString() ?? '0') ?? 0.0,
    permalink: json['Permalink'] ?? '',     // fixed casing
    fbLink: json['fb_Link'],                // fixed key
    webapp: json['Webapp'],                 // fixed casing
    status: json['status'] ?? 'Inactive',
  );
}


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': productId,
      'productName': productName,
      'productFullName': productFullName,
      'ProductImage': productImage,
      'category': category,
      'subCategory': subCategory,
      'platform': platform,
      'currency_amount': currencyAmount,
      'permalink': permalink,
      'fbLink': fbLink,
      'webapp': webapp,
      'status': status,
    };
  }
}
