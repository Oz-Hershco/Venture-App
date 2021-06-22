import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:venture_app/models/comment.dart';
import 'package:venture_app/models/filter_item.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/models/venturelocation.dart';
import 'package:venture_app/models/venturetag.dart';

class Venture {
  final String id;
  final String title;
  final String description;
  final List<FilterItem> type;
  final VentureLocation position;
  final List<String> images;
  final DateTime timestamp;
  final String creatorId;
  final List<VentureTag> tags;
  final List<User> likes;
  final List<Comment> comments;

  Venture({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.type,
    @required this.position,
    @required this.images,
    @required this.timestamp,
    @required this.creatorId,
    @required this.tags,
    @required this.likes,
    @required this.comments,
  });
}
