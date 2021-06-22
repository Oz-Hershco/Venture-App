import 'dart:io';

import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final String imgSrc;
  final double height;
  final double width;
  final EdgeInsets margin;
  CircularImage({
    this.imgSrc,
    this.height,
    this.width,
    this.margin,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          width: .25,
          color: Colors.black.withOpacity(.5),
        ),
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: imgSrc.length > 0
            ? (imgSrc.contains('https://')
                ? Image.network(
                    imgSrc,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(imgSrc),
                    fit: BoxFit.cover,
                  ))
            : FittedBox(
              child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.black.withOpacity(.05),
                  child: Center(
                      child: Icon(
                    Icons.person,
                    color: Colors.black.withOpacity(.1),
                  )),
                ),
            ),
      ),
    );
  }
}
