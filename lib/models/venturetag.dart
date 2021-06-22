import 'package:flutter/foundation.dart';

class VentureTag {
  final String id;
  final String name;

  VentureTag({@required this.id, @required this.name});

  VentureTag.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
