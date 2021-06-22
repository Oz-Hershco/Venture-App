import 'dart:io';

import 'package:flutter/material.dart';

class VentureImage extends StatelessWidget {
  final String type;
  final BoxFit fit;
  final double imageHeight;
  final double imageWidth;
  final double imageContainerHeight;
  final double imageContainerWidth;
  final File file;
  final String src;

  VentureImage({
    @required this.type,
    this.fit,
    this.imageContainerHeight,
    this.imageContainerWidth,
    this.imageHeight,
    this.imageWidth,
    this.file,
    this.src,
  });

  @override
  Widget build(BuildContext context) {
    Image _image;
    if (type == "file") {
      _image = Image.file(
        file,
        width: imageWidth,
        height: imageHeight,
        fit: fit,
      );
    } else if (type == "network") {
      _image = Image.network(
        src,
        width: imageWidth,
        height: imageHeight,
        fit: fit,
      );
    }

    return Container(
      height: imageContainerHeight,
      width: imageContainerWidth,
      child: _image,
    );
  }
}
