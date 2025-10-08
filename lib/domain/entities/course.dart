import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String productFullName;
  final String productImage;
  final String category;
  final String subCategory;
  final String platform;
  final double currencyAmount;
  final String permalink;
  final String? fbLink;
  final String? webapp;
  final String status;

  const Course({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productFullName,
    required this.productImage,
    required this.category,
    required this.subCategory,
    required this.platform,
    required this.currencyAmount,
    required this.permalink,
    this.fbLink,
    this.webapp,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        productFullName,
        productImage,
        category,
        subCategory,
        platform,
        currencyAmount,
        permalink,
        fbLink,
        webapp,
        status,
      ];
}