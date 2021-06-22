import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:venture_app/models/venture.dart';

class VentureProvider with ChangeNotifier{
  Venture _item = Venture(
    id: Uuid().v4().toString(),
    type: null,
    title: "",
    description: "",
    position: null,
    timestamp: null,
    creatorId: "",
    images: [],
    tags: [],
    likes: [],
    comments: [],
  );

  Venture get item {
    return _item;
  }

  void removeSingleVentureImage(int imageIndex) {
    _item.images.removeAt(imageIndex);
    notifyListeners();
  }

  void addSingleVentureImage(String src) {
    _item.images.add(src);
    notifyListeners();
  }

  void updateSingleVenture(Venture venture) {
    _item = venture;
    notifyListeners();
  }
}