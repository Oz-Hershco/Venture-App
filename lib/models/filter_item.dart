import 'package:flutter/foundation.dart';

class FilterItem {
  final String id;
  final String name;
  final String iconSrc;
  bool isActive;

  FilterItem({
    @required this.id,
    @required this.name,
    @required this.iconSrc,
    @required this.isActive,
  });

  FilterItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        iconSrc = json['iconSrc'],
        isActive = json['isActive'];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconSrc': iconSrc,
      'isActive': isActive,
    };
  }
}
